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
#include "arrow/ipc/writer.h"
#include "arrow/matlab/error/error.h"
#include "arrow/matlab/io/ipc/proxy/record_batch_file_writer.h"
#include "arrow/matlab/tabular/proxy/record_batch.h"
#include "arrow/matlab/tabular/proxy/schema.h"
#include "arrow/util/utf8.h"

#include "libmexclass/proxy/ProxyManager.h"

#include <iostream>

namespace arrow::matlab::io::ipc::proxy {
  
  RecordBatchFileWriter::RecordBatchFileWriter(std::shared_ptr<arrow::ipc::RecordBatchWriter> writer) : writer{std::move(writer)} {
    REGISTER_METHOD(RecordBatchFileWriter, writeBatch);
  }

libmexclass::proxy::MakeResult RecordBatchFileWriter::make(
    const libmexclass::proxy::FunctionArguments& constructor_arguments) {
    namespace mda = ::matlab::data;
    using RecordBatchFileWriterProxy = arrow::matlab::io::ipc::proxy::RecordBatchFileWriter;
    using SchemaProxy = arrow::matlab::tabular::proxy::Schema;

    mda::StructArray opts = constructor_arguments[0];
    const mda::TypedArray<uint64_t> arrow_schema_proxy_id_mda = opts[0]["SchemaProxyID"];
    const mda::StringArray filename_mda = opts[0]["Filename"];

    const auto filename_utf16 = std::u16string(filename_mda[0]);
    MATLAB_ASSIGN_OR_ERROR(const auto filename_utf8,
                          arrow::util::UTF16StringToUTF8(filename_utf16),
                          error::UNICODE_CONVERSION_ERROR_ID);

    auto proxy = libmexclass::proxy::ProxyManager::getProxy(arrow_schema_proxy_id_mda[0]);
    auto arrow_schema_proxy = std::static_pointer_cast<SchemaProxy>(proxy);

    auto arrow_schema = arrow_schema_proxy->unwrap();

    MATLAB_ASSIGN_OR_ERROR(auto output_stream,
                          arrow::io::FileOutputStream::Open(filename_utf8),
                          error::FAILED_TO_OPEN_FILE_FOR_WRITE);

    MATLAB_ASSIGN_OR_ERROR(auto writer, 
                          arrow::ipc::MakeFileWriter(output_stream, arrow_schema),
                          "arrow:matlab:MakeFailed");

    return std::make_shared<RecordBatchFileWriterProxy>(std::move(writer));
  }

  void RecordBatchFileWriter::writeBatch(libmexclass::proxy::method::Context& context) {
    namespace mda = ::matlab::data;
    using RecordBatchProxy = ::arrow::matlab::tabular::proxy::RecordBatch;

    mda::StructArray opts = context.inputs[0];
    const mda::TypedArray<uint64_t> record_batch_proxy_id_mda = opts[0]["RecordBatchProxyID"];
    const uint64_t record_batch_proxy_id = record_batch_proxy_id_mda[0];

    auto proxy = libmexclass::proxy::ProxyManager::getProxy(record_batch_proxy_id);
    auto record_batch_proxy = std::static_pointer_cast<RecordBatchProxy>(proxy);

    auto record_batch = record_batch_proxy->unwrap();

    MATLAB_ERROR_IF_NOT_OK_WITH_CONTEXT(writer->WriteRecordBatch(*record_batch), context, "arrow:matlab:writefailed");
  }
} // namespace arrow::matlab::io::ipc::proxy