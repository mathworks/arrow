%RECORDBATCHFILEREADER Class for reading record batches from data serialized
% to the IPC format.

% Licensed to the Apache Software Foundation (ASF) under one or more
% contributor license agreements.  See the NOTICE file distributed with
% this work for additional information regarding copyright ownership.
% The ASF licenses this file to you under the Apache License, Version
% 2.0 (the "License"); you may not use this file except in compliance
% with the License.  You may obtain a copy of the License at
%
%   http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
% implied.  See the License for the specific language governing
% permissions and limitations under the License.

classdef RecordBatchFileReader < matlab.mixin.Scalar

    properties (GetAccess=public, SetAccess=private, Hidden)
        Proxy
    end

    properties (SetAccess=private, GetAccess=public)
        Filename (1, 1) string
    end

    properties(Dependent, SetAccess=private, GetAccess=public)
        NumRecordBatches
    end

    methods
        function obj = RecordBatchFileReader(filename)
            arguments
                filename(1, 1) string {mustBeNonzeroLengthText}
            end
            obj.Filename = filename;
            args = struct(Filename=obj.Filename);
            obj.Proxy = arrow.internal.proxy.create("arrow.io.ipc.proxy.RecordBatchFileReader", args);
        end

        function rb = read(obj, index)
            arguments
                obj(1, 1) arrow.io.ipc.RecordBatchFileReader
                index(1, 1) int32
            end
            args = struct(Index=index);
            recordBatchproxyID = obj.Proxy.readRecordBatch(args);
            proxy = libmexclass.proxy.Proxy(Name="arrow.tabular.proxy.RecordBatch", ID=recordBatchproxyID);
            rb = arrow.tabular.RecordBatch(proxy);
        end

        function numRecordBatches = get.NumRecordBatches(obj)
            arguments
                obj(1, 1) arrow.io.ipc.RecordBatchFileReader
            end
            numRecordBatches = obj.Proxy.getNumRecordBatches();
        end
    end

end