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

#include "arrow/matlab/c/proxy/schema_c_struct.h"
#include "libmexclass/proxy/Proxy.h"

namespace arrow::matlab::c::proxy {
  SchemaCStruct::SchemaCStruct() : schema_c_struct{new ArrowSchema{}} {
      REGISTER_METHOD(SchemaCStruct, getAddress);
  }

  libmexclass::proxy::MakeResult SchemaCStruct::make(const libmexclass::proxy::FunctionArguments& constructor_arguments) {
    return std::make_shared<SchemaCStruct>();
  }

  SchemaCStruct::~SchemaCStruct() {
    if (schema_c_struct != nullptr) { 
      if (schema_c_struct->release != nullptr) {
        schema_c_struct->release(schema_c_struct);
        schema_c_struct->release = nullptr;
      }
      free(schema_c_struct);
    }
  }

  void SchemaCStruct::getAddress(libmexclass::proxy::method::Context& context) {
    namespace mda = ::matlab::data;
    
    mda::ArrayFactory factory;
    auto address = reinterpret_cast<uint64_t>(schema_c_struct);
    context.outputs[0] = factory.createScalar(address);
  }


}  // namespace arrow::matlab::c::proxy
