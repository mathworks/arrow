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

#include "arrow/record_batch.h"
#include "arrow/c/bridge.h"

#include "arrow/matlab/c/proxy/record_batch_importer.h"
#include "arrow/matlab/tabular/proxy/record_batch.h"
#include "arrow/matlab/error/error.h"

#include "libmexclass/proxy/ProxyManager.h"

namespace arrow::matlab::c::proxy {
  
  RecordBatchImporter::RecordBatchImporter() {
    // Register Proxy methods.
      REGISTER_METHOD(RecordBatchImporter, importFromC);
    }

  libmexclass::proxy::MakeResult RecordBatchImporter::make(const libmexclass::proxy::FunctionArguments& constructor_arguments) {
    return std::make_shared<RecordBatchImporter>();
  }

  void RecordBatchImporter::importFromC(libmexclass::proxy::method::Context& context) {
    namespace mda = ::matlab::data;
    using namespace libmexclass::proxy;
    using RecordBatchProxy = arrow::matlab::tabular::proxy::RecordBatch;

    mda::StructArray args = context.inputs[0];
    const mda::TypedArray<uint64_t> array_address_mda = args[0]["ArrowArrayAddress"];
    const mda::TypedArray<uint64_t> schema_address_mda = args[0]["ArrowSchemaAddress"];
    
    const auto array_address = uint64_t(array_address_mda[0]);
    const auto schema_address = uint64_t(schema_address_mda[0]);

    struct ArrowArray* arrow_array = reinterpret_cast<struct ArrowArray*>(array_address);
    struct ArrowSchema* arrow_schema = reinterpret_cast<struct ArrowSchema*>(schema_address);

    MATLAB_ASSIGN_OR_ERROR_WITH_CONTEXT(std::shared_ptr<arrow::RecordBatch> record_batch,
                                      arrow::ImportRecordBatch(arrow_array, arrow_schema),
                                      context, "arrow:c:ImportFailed");
    
    auto record_batch_proxy = std::make_shared<RecordBatchProxy>(record_batch);

    mda::ArrayFactory factory;
    const auto record_batch_proxy_id = ProxyManager::manageProxy(record_batch_proxy);
    const auto record_batch_proxy_id_mda = factory.createScalar(record_batch_proxy_id);
    context.outputs[0] = record_batch_proxy_id_mda;
  }

} // namespace arrow::matlab::c::proxy