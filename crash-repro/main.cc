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

#include <iostream>
#include <numeric>

#include "arrow/io/file.h"
#include "arrow/ipc/feather.h"
#include "arrow/result.h"
#include "arrow/status.h"
#include "arrow/table.h"
#include "arrow/type_fwd.h"
#include "arrow/type_traits.h"
#include "arrow/array/builder_primitive.h"


template <typename CType>
arrow::Result<std::shared_ptr<arrow::Array>> make_numeric_array(std::vector<CType> values) {
  using TypeClass = typename arrow::CTypeTraits<CType>::ArrowType;
  
  arrow::NumericBuilder<TypeClass> builder;

  ARROW_RETURN_NOT_OK(builder.AppendValues(values));

  std::shared_ptr<arrow::Array> array;
  ARROW_RETURN_NOT_OK(builder.Finish(&array)); 

  return array;
}

arrow::Result<std::shared_ptr<arrow::Table>> make_table() {
  std::vector<double> doubleValues = {1.0, 2.0, 3.0, 4.0};
  std::vector<int32_t> int32Values = {1, 2, 3, 4};
  std::cout << "1" << std::endl;
  auto maybeDoubleArray = make_numeric_array(doubleValues);
  if (!maybeDoubleArray.ok()) {
    std::cout << "Status is : " << maybeDoubleArray.status().mesage() << std::endl;
  }

  ARROW_ASSIGN_OR_RAISE(auto doubleArray, maybeDoubleArray);

  std::cout << "after " << std::endl;
  ARROW_ASSIGN_OR_RAISE(auto doubleArray, make_numeric_array(doubleValues));
   std::cout << "2" << std::endl;

  ARROW_ASSIGN_OR_RAISE(auto int32Array, make_numeric_array(int32Values));
  std::cout << "3" << std::endl;

  std::vector<std::shared_ptr<arrow::Array>> columns = {doubleArray, int32Array};
  auto tableSchema = arrow::schema({arrow::field("A", doubleArray->type()), arrow::field("B", int32Array->type())});
  
  return arrow::Table::Make(tableSchema, columns);
}

arrow::Status write_feather_file(std::shared_ptr<arrow::Table> table, const std::string& filename) {
  ARROW_ASSIGN_OR_RAISE(auto output_stream, arrow::io::FileOutputStream::Open(filename));

  arrow::ipc::feather::WriteProperties write_props;
  write_props.version = arrow::ipc::feather::kFeatherV1Version;

  return arrow::ipc::feather::WriteTable(*table, output_stream.get(), write_props);
}


int main(int argc, char* argv[]) { 
  if (argc < 2) {
    std::cout << "usage: my_example <filename>";
    return 1;
  }
  std::string filename{argv[1]};
  std::cout << "Filename is " << filename << std::endl;

  auto maybe_table = make_table();
    std::cout << "4" << std::endl;

  if (!maybe_table.ok()) { return 1; }
    std::cout << "5" << std::endl;

  // auto table = maybe_table.ValueOrDie();
  // std::cout << table->ToString() << std::endl;
  return 0;

  // auto write_status = write_feather_file(table, filename);
  
  // int exit_value = write_status.ok() ? 0 : 1;
  // if (exit_value == 0) {
  //   std::cout << "Write Succeeded!!" << std::endl;
  // } else {
  //   std::cout << "Write failed :(" << std::endl;
  // }
  // return exit_value;
}	