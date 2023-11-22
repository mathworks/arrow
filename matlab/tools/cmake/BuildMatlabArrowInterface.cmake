# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

# ----------------------------------
# Configure libmexclass FetchContent
# ----------------------------------


function print_find_matlab_variables()
  message(STATUS "Matlab_ROOT_DIR = ${Matlab_ROOT_DIR}")
  message(STATUS "Matlab_VERSION_STRING = ${Matlab_VERSION_STRING}")
  message(STATUS "Matlab_MAIN_PROGRAM = ${Matlab_MAIN_PROGRAM}")
  message(STATUS "Matlab_MX_LIBRARY = ${Matlab_MEX_LIBRARY}")
  message(STATUS "Matlab_MEX_LIBRARY = ${Matlab_MEX_LIBRARY}")
  message(STATUS "Matlab_ENG_LIBRARY = ${Matlab_ENG_LIBRARY}")
  message(STATUS "Matlab_ENGINE_LIBRARY = ${Matlab_ENGINE_LIBRARY}")
  message(STATUS "Matlab_DATAARRAY_LIBRARY = ${Matlab_DATAARRAY_LIBRARY}")
  message(STATUS "Matlab_MAT_LIBRARY = ${Matlab_MAT_LIBRARY}")
  message(STATUS "MEX_API_MACRO = ${MEX_API_MACRO}")  
  message(STATUS "Matlab_MEX_COMPILER = ${Matlab_MEX_COMPILER}")
  message(STATUS "Matlab_HAS_CPP_API = ${Matlab_HAS_CPP_API}")
  message(STATUS "Matlab_MEX_EXTENSION = ${Matlab_MEX_EXTENSION}")
  message(STATUS "MEX_VERSION_FILE = ${MEX_VERSION_FILE}")
  message(STATUS "Matlab_INCLUDE_DIRS = ${Matlab_INCLUDE_DIRS}")
  message(STATUS "Matlab_BINARIES_DIR = ${Matlab_BINARIES_DIR}")
  message(STATUS "Matlab_EXTERN_LIBRARY_DIR = ${Matlab_EXTERN_LIBRARY_DIR}")
  message(STATUS "Matlab_EXTERN_BINARIES_DIR = ${Matlab_EXTERN_BINARIES_DIR}")
endfunction()

function(set_matlab_variables)
  string(FIND "${MATLAB_ADDITIONAL_VERSIONS}" "=" equal_char_pos)
  message(STATUS "equal_char_pos = ${equal_char_pos}")
  
endfunction()

set(MATLAB_ADDITIONAL_VERSIONS "R2023b=23.2")
set(Matlab_ROOT_DIR "C:/Program Files/MATLAB/R2023b")
message(STATUS "MATLAB_ADDITIONAL_VERSOINS = ${MATLAB_ADDITIONAL_VERSIONS}")
message(STATUS "Matlab_ROOT_DIR = ${Matlab_ROOT_DIR}")
find_package(Matlab REQUIRED)
set_matlab_variables()

message(STATUS "MATLAB_ADDITIONAL_VERSOINS = ${MATLAB_ADDITIONAL_VERSIONS}")
message(STATUS "Matlab_ROOT_DIR = ${Matlab_ROOT_DIR}")

set(MATLAB_ARROW_LIBMEXCLASS_CLIENT_FETCH_CONTENT_NAME libmexclass)
# TODO: Consider using SSH URL for the Git Repository when
# libmexclass is accessible for CI without permission issues.
set(MATLAB_ARROW_LIBMEXCLASS_CLIENT_FETCH_CONTENT_GIT_REPOSITORY "https://github.com/mathworks/libmexclass.git")
# Use a specific Git commit hash to avoid libmexclass version changing unexpectedly.
set(MATLAB_ARROW_LIBMEXCLASS_CLIENT_FETCH_CONTENT_GIT_TAG "d04f88d")
                                                           
set(MATLAB_ARROW_LIBMEXCLASS_CLIENT_FETCH_CONTENT_SOURCE_SUBDIR "libmexclass/cpp")

# ------------------------------------------
# Configure libmexclass Client Proxy Library
# ------------------------------------------

set(MATLAB_ARROW_LIBMEXCLASS_CLIENT_PROXY_LIBRARY_NAME arrowproxy)
set(MATLAB_ARROW_LIBMEXCLASS_CLIENT_PROXY_LIBRARY_ROOT_INCLUDE_DIR "${CMAKE_SOURCE_DIR}/src/cpp")
set(MATLAB_ARROW_LIBMEXCLASS_CLIENT_PROXY_INCLUDE_DIR "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/array/proxy"
                                                      "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/bit"
                                                      "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/error"
                                                      "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/type"
                                                      "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/type/proxy"
                                                      "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/buffer")

set(MATLAB_ARROW_LIBMEXCLASS_CLIENT_PROXY_SOURCES "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/array/proxy/array.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/array/proxy/boolean_array.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/array/proxy/string_array.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/array/proxy/timestamp_array.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/array/proxy/time32_array.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/array/proxy/time64_array.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/array/proxy/struct_array.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/array/proxy/list_array.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/array/proxy/chunked_array.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/array/proxy/wrap.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/tabular/proxy/record_batch.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/tabular/proxy/table.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/tabular/proxy/schema.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/bit/pack.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/bit/unpack.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/type/time_unit.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/type/proxy/type.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/type/proxy/fixed_width_type.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/type/proxy/string_type.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/type/proxy/date_type.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/type/proxy/date32_type.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/type/proxy/date64_type.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/type/proxy/timestamp_type.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/type/proxy/time_type.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/type/proxy/time32_type.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/type/proxy/time64_type.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/type/proxy/struct_type.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/type/proxy/list_type.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/type/proxy/field.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/type/proxy/wrap.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/io/feather/proxy/writer.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/io/feather/proxy/reader.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/io/csv/proxy/table_writer.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/io/csv/proxy/table_reader.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/index/validate.cc"
                                                  "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/buffer/proxy/buffer.cc")


set(MATLAB_ARROW_LIBMEXCLASS_CLIENT_PROXY_FACTORY_INCLUDE_DIR "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/proxy")
set(MATLAB_ARROW_LIBMEXCLASS_CLIENT_PROXY_FACTORY_SOURCES "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/proxy/factory.cc")
set(MATLAB_ARROW_LIBMEXCLASS_CLIENT_PROXY_LIBRARY_INCLUDE_DIRS ${MATLAB_ARROW_LIBMEXCLASS_CLIENT_PROXY_LIBRARY_ROOT_INCLUDE_DIR}
                                                               ${MATLAB_ARROW_LIBMEXCLASS_CLIENT_PROXY_INCLUDE_DIR}
                                                               ${MATLAB_ARROW_LIBMEXCLASS_CLIENT_PROXY_FACTORY_INCLUDE_DIR})
set(MATLAB_ARROW_LIBMEXCLASS_CLIENT_PROXY_LIBRARY_SOURCES ${MATLAB_ARROW_LIBMEXCLASS_CLIENT_PROXY_SOURCES}
                                                          ${MATLAB_ARROW_LIBMEXCLASS_CLIENT_PROXY_FACTORY_SOURCES})
# ----------------------------------------
# Configure libmexclass Client MEX Gateway
# ----------------------------------------

set(MATLAB_ARROW_LIBMEXCLASS_CLIENT_MEX_GATEWAY_NAME gateway)
set(MATLAB_ARROW_LIBMEXCLASS_CLIENT_MEX_GATEWAY_SOURCES "${CMAKE_SOURCE_DIR}/src/cpp/arrow/matlab/mex/gateway.cc")

# ---------------------------------------
# Download libmexclass Using FetchContent
# ---------------------------------------

# Include libmexclass using FetchContent.
include(FetchContent)
FetchContent_Declare(
    ${MATLAB_ARROW_LIBMEXCLASS_CLIENT_FETCH_CONTENT_NAME}
    GIT_REPOSITORY ${MATLAB_ARROW_LIBMEXCLASS_CLIENT_FETCH_CONTENT_GIT_REPOSITORY}
    GIT_TAG ${MATLAB_ARROW_LIBMEXCLASS_CLIENT_FETCH_CONTENT_GIT_TAG}
    SOURCE_SUBDIR ${MATLAB_ARROW_LIBMEXCLASS_CLIENT_FETCH_CONTENT_SOURCE_SUBDIR}
)
FetchContent_MakeAvailable(
    ${MATLAB_ARROW_LIBMEXCLASS_CLIENT_FETCH_CONTENT_NAME}
)

# ------------------------------------
# Add libmexclass Client Proxy Library
# ------------------------------------

if(NOT TARGET arrow_shared)
    message(FATAL_ERROR "The Arrow C++ libraries must be available to build the MATLAB Interface to Arrow.")
endif()

libmexclass_client_add_proxy_library(
    NAME ${MATLAB_ARROW_LIBMEXCLASS_CLIENT_PROXY_LIBRARY_NAME}
    SOURCES ${MATLAB_ARROW_LIBMEXCLASS_CLIENT_PROXY_LIBRARY_SOURCES}
    INCLUDE_DIRS ${MATLAB_ARROW_LIBMEXCLASS_CLIENT_PROXY_LIBRARY_INCLUDE_DIRS}
    LINK_LIBRARIES arrow_shared
)
# Use C++17
target_compile_features(${MATLAB_ARROW_LIBMEXCLASS_CLIENT_PROXY_LIBRARY_NAME} PRIVATE cxx_std_17)
target_compile_definitions(${MATLAB_ARROW_LIBMEXCLASS_CLIENT_PROXY_LIBRARY_NAME} PRIVATE ARROW_MATLAB_EXPORTING)

# When building Arrow from source, Arrow must be built before building the client Proxy library.
if(TARGET arrow_ep)
    add_dependencies(${MATLAB_ARROW_LIBMEXCLASS_CLIENT_PROXY_LIBRARY_NAME} arrow_ep)
endif()

# ----------------------------------
# Add libmexclass Client MEX Gateway
# ----------------------------------

libmexclass_client_add_mex_gateway(
    NAME ${MATLAB_ARROW_LIBMEXCLASS_CLIENT_MEX_GATEWAY_NAME}
    CLIENT_PROXY_LIBRARY_NAME ${MATLAB_ARROW_LIBMEXCLASS_CLIENT_PROXY_LIBRARY_NAME}
    SOURCES ${MATLAB_ARROW_LIBMEXCLASS_CLIENT_MEX_GATEWAY_SOURCES}
)

# --------------------------
# Install libmexclass Client
# --------------------------

libmexclass_client_install(
    CLIENT_PROXY_LIBRARY_NAME ${MATLAB_ARROW_LIBMEXCLASS_CLIENT_PROXY_LIBRARY_NAME}
    CLIENT_MEX_GATEWAY_NAME ${MATLAB_ARROW_LIBMEXCLASS_CLIENT_MEX_GATEWAY_NAME}
    DESTINATION ${CMAKE_INSTALL_DIR}
)
