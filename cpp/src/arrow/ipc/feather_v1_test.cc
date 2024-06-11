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

#include <functional>
#include <memory>
#include <string>
#include <tuple>
#include <utility>
#include <iostream>
#include <numeric>

#include <gtest/gtest.h>

#include "arrow/array.h"
#include "arrow/buffer.h"
#include "arrow/ipc/feather.h"
#include "arrow/record_batch.h"
#include "arrow/status.h"
#include "arrow/table.h"
#include "arrow/testing/gtest_util.h"
#include "arrow/type.h"
#include "arrow/io/file.h"
#include "arrow/result.h"
#include "arrow/type_fwd.h"
#include "arrow/type_traits.h"
#include "arrow/array/builder_primitive.h"

namespace {
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

    ARROW_ASSIGN_OR_RAISE(auto doubleArray, make_numeric_array(doubleValues));

    ARROW_ASSIGN_OR_RAISE(auto int32Array, make_numeric_array(int32Values));

    std::vector<std::shared_ptr<arrow::Array>> columns = {doubleArray, int32Array};
    auto tableSchema = arrow::schema({arrow::field("A", doubleArray->type()), arrow::field("B", int32Array->type())});

    return arrow::Table::Make(tableSchema, columns);
  }
}

TEST(WriteFeatherV1File, Smoke) {
  auto props = WriteProperties::Defaults();

  std::string filename = "testfeather.feater";
  ASSERT_TRUE(maybe_table.ok());
  auto table = maybe_table.ValueOrDie();
  std::cout << "Table: " << std::endl;
  std::cout << table->ToString() << std::endl;

  auto maybe_output_stream = arrow::io::FileOutputStream::Open(filename);
  ASSERT_TRUE(maybe_output_stream.ok());
  auto output_stream = maybe_output_stream.ValueOrDie();
  std::cout << "Made file output stream" << std::endl;
  arrow::ipc::feather::WriteProperties write_props;
  write_props.version = arrow::ipc::feather::kFeatherV1Version;
  auto st = arrow::ipc::feather::WriteTable(*table, output_stream.get(), write_props);
  ASSERT_TRUE(st.ok());
  std::cout << "Write feather v1 file" << std::endl;
}