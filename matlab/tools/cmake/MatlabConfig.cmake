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

macro(MatlabPrintVariables)
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
endmacro()

macro(MatlabConfigure)
  find_package(Matlab REQUIRED)
  if (${Matlab_VERSION_STRING} STREQUAL "unknown")
    message(STATUS "Matlab_VERSION_STRING is unknown")
    if (NOT DEFINED MATLAB_RELEASE_VERSION)
      # Temporarily require users to supply MATLAB_RELEASE_VERSION if find_package(Matlab)
      # fails to derive the version from the root directory. We can probably determine this
      # ourselves by examining the VersionInfo.xml file.
      message(FATAL_ERROR "Must supply MATLAB_RELEASE_VERSION")
    endif()

    set(Matlab_VERSION_STRING "${MATLAB_RELEASE_VERSION}")
    set(Matlab_ENGINE_LIBRARY "${Matlab_ROOT_DIR}/extern/lib/win64/microsoft/libMatlabEngine.lib")
    set(Matlab_DATAARRAY_LIBRARY "${Matlab_ROOT_DIR}/extern/lib/win64/microsoft/libMatlabDataArray.lib")
    set(Matlab_MEX_LIBRARY "${Matlab_ROOT_DIR}/extern/lib/win64/microsoft/libmex.lib")
    set(Matlab_HAS_CPP_API 1)
    set(Matlab_MX_LIBRARY "${Matlab_ROOT_DIR}/extern/lib/win64/microsoft/libmex.lib")
    set(Matlab_EXTERN_LIBRARY_DIR "${Matlab_ROOT_DIR}/extern/lib/win64")
    set(Matlab_INCLUDE_DIRS "${Matlab_ROOT_DIR}/extern/include")
    set(Matlab_BINARIES_DIR "${Matlab_ROOT_DIR}/bin/win64")
    set(Matlab_EXTERN_BINARIES_DIR "${Matlab_ROOT_DIR}/extern/bin/win64")
    # Print Matlab-specific variables after set
    MatlabPrintVariables()
  endif()

endmacro()
