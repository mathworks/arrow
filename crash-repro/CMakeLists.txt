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

cmake_minimum_required(VERSION 3.16)

# Build the Arrow C++ libraries using ExternalProject_Add.
function(build_arrow)
  set(ARROW_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/arrow_ep-prefix")
  set(ARROW_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/arrow_ep-build")
  set(ARROW_CMAKE_ARGS
      "-DCMAKE_INSTALL_PREFIX=${ARROW_PREFIX}" "-DCMAKE_INSTALL_LIBDIR=lib"
      "-DARROW_BUILD_STATIC=OFF")

  add_library(arrow_shared SHARED IMPORTED)
  set(ARROW_LIBRARY_TARGET arrow_shared)

  # Set the runtime shared library (.dll, .so, or .dylib)
  if(WIN32)
    # The shared library (i.e. .dll) is located in the "bin" directory.
    set(ARROW_SHARED_LIBRARY_DIR "${ARROW_PREFIX}/bin")
  else()
    # The shared library (i.e. .so or .dylib) is located in the "lib" directory.
    set(ARROW_SHARED_LIBRARY_DIR "${ARROW_PREFIX}/lib")
  endif()

  set(ARROW_SHARED_LIB_FILENAME
      "${CMAKE_SHARED_LIBRARY_PREFIX}arrow${CMAKE_SHARED_LIBRARY_SUFFIX}")
  set(ARROW_SHARED_LIB "${ARROW_SHARED_LIBRARY_DIR}/${ARROW_SHARED_LIB_FILENAME}")

  set_target_properties(arrow_shared PROPERTIES IMPORTED_LOCATION ${ARROW_SHARED_LIB})

  # Set the link-time import library (.lib)
  if(WIN32)
    # The import library (i.e. .lib) is located in the "lib" directory.
    set(ARROW_IMPORT_LIB_FILENAME
        "${CMAKE_IMPORT_LIBRARY_PREFIX}arrow${CMAKE_IMPORT_LIBRARY_SUFFIX}")
    set(ARROW_IMPORT_LIB "${ARROW_PREFIX}/lib/${ARROW_IMPORT_LIB_FILENAME}")

    set_target_properties(arrow_shared PROPERTIES IMPORTED_IMPLIB ${ARROW_IMPORT_LIB})
  endif()

  # Set the include directories
  set(ARROW_INCLUDE_DIR "${ARROW_PREFIX}/include")
  file(MAKE_DIRECTORY "${ARROW_INCLUDE_DIR}")
  set_target_properties(arrow_shared PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                                                ${ARROW_INCLUDE_DIR})

  # Set the build byproducts for the ExternalProject build
  if(WIN32)
    set(ARROW_BUILD_BYPRODUCTS "${ARROW_IMPORT_LIB}")
  else()
    set(ARROW_BUILD_BYPRODUCTS "${ARROW_SHARED_LIB}")
  endif()

  # Building the Arrow C++ libraries requires ExternalProject.
  include(ExternalProject)

  externalproject_add(arrow_ep
                      SOURCE_DIR "${CMAKE_SOURCE_DIR}/../cpp"
                      BINARY_DIR "${ARROW_BINARY_DIR}"
                      CMAKE_ARGS "${ARROW_CMAKE_ARGS}"
                      BUILD_BYPRODUCTS "${ARROW_BUILD_BYPRODUCTS}")

  add_dependencies(${ARROW_LIBRARY_TARGET} arrow_ep)

endfunction()


function(install_imported_target)
    # TODO: Add required argument logic.
    set(options)
    set(oneValueArgs NAME DESTINATION)
    set(multiValueArgs)
    cmake_parse_arguments(INSTALL_IMPORTED_TARGET "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    get_target_property(RUNTIME_LIBRARY ${INSTALL_IMPORTED_TARGET_NAME} IMPORTED_LOCATION)
    if (NOT ${RUNTIME_LIBRARY})
        get_target_property(RUNTIME_LIBRARY ${INSTALL_IMPORTED_TARGET_NAME} LOCATION)
    endif()
    get_filename_component(RUNTIME_LIBRARY_FILENAME_NO_EXT ${RUNTIME_LIBRARY} NAME_WE)
    get_filename_component(RUNTIME_LIBRARY_DIRECTORY ${RUNTIME_LIBRARY} DIRECTORY)
    set(RUNTIME_LIBRARY_BASE_FILENAME "${RUNTIME_LIBRARY_DIRECTORY}/${RUNTIME_LIBRARY_FILENAME_NO_EXT}${CMAKE_SHARED_LIBRARY_SUFFIX}")
    set(RUNTIME_LIBRARY_TEMP_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/install_runtime_libraries/${RUNTIME_LIBRARY_FILENAME_NO_EXT}")
    install(CODE "file(COPY ${RUNTIME_LIBRARY_BASE_FILENAME} DESTINATION ${RUNTIME_LIBRARY_TEMP_DIRECTORY} FOLLOW_SYMLINK_CHAIN)")
    install(DIRECTORY ${RUNTIME_LIBRARY_TEMP_DIRECTORY}/ DESTINATION ${INSTALL_IMPORTED_TARGET_DESTINATION})
endfunction()


set(CMAKE_CXX_STANDARD 17)
project(write_feather)

# Build arrow from source
build_arrow()
get_target_property(ARROW_SHARED_LIB arrow_shared IMPORTED_LOCATION)
get_target_property(ARROW_INCLUDE_DIR arrow_shared INTERFACE_INCLUDE_DIRECTORIES)

add_executable(write_feather main.cc)
target_link_libraries(write_feather PRIVATE arrow_shared)

if(APPLE)
set_target_properties(write_feather PROPERTIES INSTALL_RPATH "@loader_path")
else()
set_target_properties(write_feather PROPERTIES INSTALL_RPATH "$ORIGIN")
endif()

install(TARGETS write_feather DESTINATION ${CMAKE_INSTALL_PREFIX})
install_imported_target(NAME arrow_shared DESTINATION ${CMAKE_INSTALL_PREFIX})