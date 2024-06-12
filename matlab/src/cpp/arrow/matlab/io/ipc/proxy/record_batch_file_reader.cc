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

#include "arrow/io/file.h"
#include "arrow/io/interfaces.h"
#include "arrow/ipc/reader.h"
#include "arrow/matlab/error/error.h"
#include "arrow/matlab/io/ipc/proxy/record_batch_file_reader.h"
#include "arrow/util/utf8.h"


namespace arrow::matlab::io::ipc::proxy {

RecordBatchFileReader::RecordBatchFileReader(std::shared_ptr<arrow::ipc::RecordBatchFileReader> reader) : reader{std::move(reader)} {
  REGISTER_METHOD(RecordBatchFileReader, getNumRecordBatches);
}

libmexclass::proxy::MakeResult RecordBatchFileReader::make(const libmexclass::proxy::FunctionArguments& constructor_arguments) {
  namespace mda = ::matlab::data;
  using RecordBatchFileReaderProxy = arrow::matlab::io::ipc::proxy::RecordBatchFileReader;

  mda::StructArray opts = constructor_arguments[0];
  const mda::StringArray filename_mda = opts[0]["Filename"];

  const auto filename_utf16 = std::u16string(filename_mda[0]);
  MATLAB_ASSIGN_OR_ERROR(const auto filename_utf8,
                        arrow::util::UTF16StringToUTF8(filename_utf16),
                        error::UNICODE_CONVERSION_ERROR_ID);

  MATLAB_ASSIGN_OR_ERROR(auto input_stream,
                        arrow::io::ReadableFile::Open(filename_utf8),
                        error::FAILED_TO_OPEN_FILE_FOR_WRITE);
  
  MATLAB_ASSIGN_OR_ERROR(auto reader, 
                        arrow::ipc::RecordBatchFileReader::Open(input_stream),
                        "arrow:matlab:MakeFailed");

  return std::make_shared<RecordBatchFileReaderProxy>(std::move(reader));
}

void RecordBatchFileReader::getNumRecordBatches(libmexclass::proxy::method::Context& context) {
    namespace mda = ::matlab::data;
    mda::ArrayFactory factory;
    const auto num_batches = reader->num_record_batches();
    context.outputs[0] = factory.createScalar(num_batches);
}



} // namespace arrow::matlab::io::ipc::proxy