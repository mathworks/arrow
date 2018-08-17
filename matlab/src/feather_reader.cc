// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

#include <algorithm>

#include <arrow/io/file.h>
#include <arrow/ipc/feather.h>
#include <arrow/status.h>
#include <arrow/table.h>
#include <arrow/type.h>
#include <arrow/util/bit-util.h>

#include <mex.h>

#include "feather_reader.h"
#include "matlab_traits.h"
#include "util/handle_status.h"

namespace mlarrow {

namespace internal {

// Read the name of variable i from the Feather file as a mxArray*.
mxArray* ReadVariableName(const std::shared_ptr<arrow::Column>& column) {
  return mxCreateString(column->name().c_str());
}

template <typename ArrowDataType>
mxArray* ReadNumericVariableData(const std::shared_ptr<arrow::Column>& column) {
  typedef typename MatlabTraits<ArrowDataType>::MatlabType MatlabType;
  typedef typename arrow::TypeTraits<ArrowDataType>::ArrayType ArrowArrayType;

  std::shared_ptr<arrow::ChunkedArray> chunked_array = column->data();
  const int num_chunks = chunked_array->num_chunks();

  const mxClassID matlab_class_id = MatlabTraits<ArrowDataType>::matlab_class_id;
  // Allocate a numeric mxArray* with the correct mxClassID based on the type of the
  // arrow::Column.
  mxArray* variable_data =
      mxCreateNumericMatrix(column->length(), 1, matlab_class_id, mxREAL);

  int64_t mx_array_offset = 0;
  // Iterate over each arrow::Array in the arrow::ChunkedArray.
  for (int i = 0; i < num_chunks; ++i) {
    std::shared_ptr<arrow::Array> array = chunked_array->chunk(i);
    const int64_t chunk_length = array->length();
    std::shared_ptr<ArrowArrayType> arr = std::static_pointer_cast<ArrowArrayType>(array);
    const auto data = arr->raw_values();
    MatlabType* dt = MatlabTraits<ArrowDataType>::GetData(variable_data);
    std::copy(data, data + chunk_length, dt + mx_array_offset);
    mx_array_offset += chunk_length;
  }

  return variable_data;
}

// Read the data of variable i from the Feather file as a mxArray*.
mxArray* ReadVariableData(const std::shared_ptr<arrow::Column>& column) {
  std::shared_ptr<arrow::DataType> type = column->type();

  switch (type->id()) {
    case arrow::Type::FLOAT:
      return ReadNumericVariableData<arrow::FloatType>(column);
    case arrow::Type::DOUBLE:
      return ReadNumericVariableData<arrow::DoubleType>(column);
    case arrow::Type::UINT8:
      return ReadNumericVariableData<arrow::UInt8Type>(column);
    case arrow::Type::UINT16:
      return ReadNumericVariableData<arrow::UInt16Type>(column);
    case arrow::Type::UINT32:
      return ReadNumericVariableData<arrow::UInt32Type>(column);
    case arrow::Type::UINT64:
      return ReadNumericVariableData<arrow::UInt64Type>(column);
    case arrow::Type::INT8:
      return ReadNumericVariableData<arrow::Int8Type>(column);
    case arrow::Type::INT16:
      return ReadNumericVariableData<arrow::Int16Type>(column);
    case arrow::Type::INT32:
      return ReadNumericVariableData<arrow::Int32Type>(column);
    case arrow::Type::INT64:
      return ReadNumericVariableData<arrow::Int64Type>(column);

    default: {
      mexErrMsgIdAndTxt("MATLAB:arrow:UnsupportedArrowType",
                        "Unsupported arrow::Type '%s' for variable '%s'",
                        type->name().c_str(), column->name().c_str());
      break;
    }
  }

  return nullptr;
}

// Read the validity (null) bitmap of variable i from the Feather
// file as an mxArray*.
mxArray* ReadVariableValidityBitmap(const std::shared_ptr<arrow::Column>& column) {
  // Allocate an mxLogical array to store the validity (null) bitmap values.
  // Note: All Arrow arrays can have an associated validity (null) bitmap.
  // The Apache Arrow specification defines 0 (false) to represent an
  // invalid (null) array entry and 1 (true) to represent a valid
  // (non-null) array entry.
  mxArray* validity_bitmap = mxCreateLogicalMatrix(column->length(), 1);
  bool* validity_bitmap_unpacked = static_cast<bool*>(mxGetLogicals(validity_bitmap));

  // The Apache Arrow specification allows validity (null) bitmaps
  // to be unallocated if there are no null values. In this case,
  // we simply return a logical array filled with the value true.
  if (column->null_count() == 0) {
    std::fill(validity_bitmap_unpacked, validity_bitmap_unpacked + column->length(),
              true);
    return validity_bitmap;
  }

  std::shared_ptr<arrow::ChunkedArray> chunked_array = column->data();
  const int num_chunks = chunked_array->num_chunks();

  int64_t mx_array_offset = 0;
  // Iterate over each arrow::Array in the arrow::ChunkedArray.
  for (int i = 0; i < num_chunks; ++i) {
    std::shared_ptr<arrow::Array> array = chunked_array->chunk(i);
    const int64_t chunk_length = array->length();

    const uint8_t* validity_bitmap_packed = array->null_bitmap()->data();
    // Unpack the bit-packed validity (null) bitmap.
    for (int64_t j = 0; j < chunk_length; ++j) {
      validity_bitmap_unpacked[mx_array_offset + j] =
          arrow::BitUtil::GetBit(validity_bitmap_packed, j);
    }

    mx_array_offset += chunk_length;
  }

  return validity_bitmap;
}

// Read the type of variable i from the Feather file as a mxArray*.
mxArray* ReadVariableType(const std::shared_ptr<arrow::Column>& column) {
  return mxCreateString(column->type()->name().c_str());
}

// MATLAB arrays cannot be larger than 2^48.
static constexpr uint64_t MAX_MATLAB_SIZE = static_cast<uint64_t>(0x01) << 48;

}  // namespace internal

arrow::Status FeatherReader::Open(const std::string& filename,
                                  std::shared_ptr<FeatherReader>* feather_reader) {
  *feather_reader = std::shared_ptr<FeatherReader>(new FeatherReader());
  // Open file with given filename as a ReadableFile.
  std::shared_ptr<arrow::io::ReadableFile> readable_file(nullptr);
  auto status = arrow::io::ReadableFile::Open(filename, &readable_file);
  if (!status.ok()) {
    return status;
  }
  // TableReader expects a RandomAccessFile.
  std::shared_ptr<arrow::io::RandomAccessFile> random_access_file(readable_file);
  // Open the Feather file for reading with a TableReader.
  status = arrow::ipc::feather::TableReader::Open(random_access_file,
                                                  &(*feather_reader)->table_reader_);
  if (!status.ok()) {
    return status;
  }

  // Read the table metadata from the Feather file.
  (*feather_reader)->num_rows_ = (*feather_reader)->table_reader_->num_rows();
  (*feather_reader)->num_variables_ = (*feather_reader)->table_reader_->num_columns();
  (*feather_reader)->description_ =
      (*feather_reader)->table_reader_->HasDescription()
          ? (*feather_reader)->table_reader_->GetDescription()
          : "";
  (*feather_reader)->version_ = (*feather_reader)->table_reader_->version();

  if ((*feather_reader)->num_rows_ > internal::MAX_MATLAB_SIZE ||
      (*feather_reader)->num_variables_ > internal::MAX_MATLAB_SIZE) {
    mexErrMsgIdAndTxt("MATLAB:arrow:SizeTooLarge",
                      "The table size exceeds MATLAB limits: %u x %u",
                      (*feather_reader)->num_rows_, (*feather_reader)->num_variables_);
  }

  return status;
}

// Read the table metadata from the Feather file as a mxArray*.
mxArray* FeatherReader::ReadMetadata() const {
  const int num_metadata_fields = 4;
  const char* fieldnames[] = {"NumRows", "NumVariables", "Description", "Version"};

  // Create a mxArray struct array containing the table metadata to be passed back to
  // MATLAB.
  mxArray* metadata = mxCreateStructMatrix(1, 1, num_metadata_fields, fieldnames);

  // Returning double values to MATLAB since that is the default type.

  // Set the number of rows.
  mxSetField(metadata, 0, "NumRows",
             mxCreateDoubleScalar(static_cast<double>(num_rows_)));

  // Set the number of variables.
  mxSetField(metadata, 0, "NumVariables",
             mxCreateDoubleScalar(static_cast<double>(num_variables_)));

  // Set the description.
  mxSetField(metadata, 0, "Description", mxCreateString(description_.c_str()));

  // Set the version.
  mxSetField(metadata, 0, "Version", mxCreateDoubleScalar(static_cast<double>(version_)));

  return metadata;
}

// Read the table variables from the Feather file as a mxArray*.
mxArray* FeatherReader::ReadVariables() const {
  const int num_variable_fields = 4;
  const char* fieldnames[] = {"Name", "Type", "Data", "Valid"};

  // Create an mxArray* struct array containing the table variables to be passed back to
  // MATLAB.
  mxArray* variables =
      mxCreateStructMatrix(1, num_variables_, num_variable_fields, fieldnames);

  // Read all the table variables in the Feather file into memory.
  for (int64_t i = 0; i < num_variables_; ++i) {
    std::shared_ptr<arrow::Column> column(nullptr);
    util::HandleStatus(table_reader_->GetColumn(i, &column));

    // set the struct fields data
    mxSetField(variables, i, "Name", internal::ReadVariableName(column));
    mxSetField(variables, i, "Type", internal::ReadVariableType(column));
    mxSetField(variables, i, "Data", internal::ReadVariableData(column));
    mxSetField(variables, i, "Valid", internal::ReadVariableValidityBitmap(column));
  }

  return variables;
}

}  // namespace mlarrow
