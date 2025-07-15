<!---
  Licensed to the Apache Software Foundation (ASF) under one
  or more contributor license agreements.  See the NOTICE file
  distributed with this work for additional information
  regarding copyright ownership.  The ASF licenses this file
  to you under the Apache License, Version 2.0 (the
  "License"); you may not use this file except in compliance
  with the License.  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing,
  software distributed under the License is distributed on an
  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  KIND, either express or implied.  See the License for the
  specific language governing permissions and limitations
  under the License.
-->

# MATLAB Interface to Apache Arrow

## Status

> **Warning** The MATLAB interface is under active development and should be considered experimental.

This is a very early stage MATLAB interface to the Apache Arrow C++ libraries.

Currently, the MATLAB interface supports:

1. Converting between a subset of Arrow `Array` types and MATLAB array types (see table below)
2. Converting between MATLAB `table`s and `arrow.tabular.RecordBatch`s
3. Creating Arrow `Field`s, `Schema`s, and `Type`s
4. Reading and writing Feather V1 files

Supported `arrow.array.Array` types are included in the table below.

**NOTE**: All Arrow `Array` classes listed below are part of the `arrow.array` package (e.g. `arrow.array.Float64Array`).

| MATLAB Array Type | Arrow Array Type |
| ----------------- | ---------------- |
| `uint8`           | `UInt8Array`     |
| `uint16`          | `UInt16Array`    |
| `uint32`          | `UInt32Array`    |
| `uint64`          | `UInt64Array`    |
| `int8`            | `Int8Array`      |
| `int16`           | `Int16Array`     |
| `int32`           | `Int32Array`     |
| `int64`           | `Int64Array`     |
| `single`          | `Float32Array`   |
| `double`          | `Float64Array`   |
| `logical`         | `BooleanArray`   |
| `string`          | `StringArray`    |
| `datetime`        | `TimestampArray` |
| `datetime`        | `Date32Array`    |
| `datetime`        | `Date64Array`    |
| `duration`        | `Time32Array`    |
| `duration`        | `Time64Array`    |
| `cell`            | `ListArray`      |
| `table`           | `StructArray`    |

## Prerequisites

To build the MATLAB Interface to Apache Arrow from source, the following software must be installed on the target machine:

1. [MATLAB](https://www.mathworks.com/products/get-matlab.html)
2. [CMake](https://cmake.org/cmake/help/latest/)
3. C++ compiler which supports C++17 (e.g. [`gcc`](https://gcc.gnu.org/) on Linux, [`Xcode`](https://developer.apple.com/xcode/) on macOS, or [`Visual Studio`](https://visualstudio.microsoft.com/) on Windows)
4. [Git](https://git-scm.com/)

## Setup

To set up a local working copy of the source code, start by cloning the [`apache/arrow`](https://github.com/apache/arrow) GitHub repository using [Git](https://git-scm.com/):

```console
$ git clone https://github.com/apache/arrow.git
```

After cloning, change the working directory to the `matlab` subdirectory:

```console
$ cd arrow/matlab
```

## Build

To build the MATLAB interface, use [CMake](https://cmake.org/cmake/help/latest/):

```console
$ cmake -S . -B build
$ cmake --build build --config Release
```

## Install

To install the MATLAB interface to the default software installation location for the target machine (e.g. `/usr/local` on Linux or `C:\Program Files` on Windows), pass the `--target install` flag to CMake.

```console
$ cmake --build build --config Release --target install
```

As part of the install step, the installation directory is added to the [MATLAB Search Path](https://mathworks.com/help/matlab/matlab_env/what-is-the-matlab-search-path.html).

**Note**: This step may fail if the current user is lacking necessary filesystem permissions. If the install step fails, the installation directory can be manually added to the MATLAB Search Path using the [`addpath`](https://www.mathworks.com/help/matlab/ref/addpath.html) command. 

## Test

To run the MATLAB tests, start MATLAB in the `arrow/matlab` directory and call the [`runtests`](https://mathworks.com/help/matlab/ref/runtests.html) command on the `test` directory with `IncludeSubFolders=true`:

``` matlab
>> runtests("test", IncludeSubFolders=true);
```

Refer to [Testing Guidelines](doc/testing_guidelines_for_the_matlab_interface_to_apache_arrow.md) for more information.

## Usage

Included below are some example code snippets that illustrate how to use the MATLAB interface.

### Feather V1

#### Write a MATLAB table to a Feather V1 file

``` matlab
>> t = table(["A"; "B"; "C"], [1; 2; 3], [true; false; true])

t =

  3×3 table

    Var1    Var2    Var3
    ____    ____    _____

    "A"      1      true
    "B"      2      false
    "C"      3      true

>> filename = "table.feather";

>> featherwrite(filename, t)
```

#### Read a Feather V1 file into a MATLAB table

``` matlab
>> filename = "table.feather";

>> t = featherread(filename)

t =

  3×3 table

    Var1    Var2    Var3
    ____    ____    _____

    "A"      1      true
    "B"      2      false
    "C"      3      true
```

