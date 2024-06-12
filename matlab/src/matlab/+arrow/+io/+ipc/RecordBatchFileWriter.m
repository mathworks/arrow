%RECORDBATCHFILEWRITER Class for serializing record batches to files using
% the IPC format. 

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

classdef RecordBatchFileWriter < matlab.mixin.Scalar

    properties (GetAccess=public, SetAccess=private, Hidden)
        Proxy
    end

    methods
        function obj = RecordBatchFileWriter(filename, schema)
            arguments
                filename(1, 1) string {mustBeNonzeroLengthText}
                schema(1, 1) arrow.tabular.Schema
            end
            args = struct(Filename=filename, SchemaProxyID=schema.Proxy.ID);
            obj.Proxy = arrow.internal.proxy.create("arrow.io.ipc.proxy.RecordBatchFileWriter", args);
        end

        function write(obj, recordBatch)
            arguments
                obj(1, 1) arrow.io.ipc.RecordBatchFileWriter
                recordBatch(1, 1) arrow.tabular.RecordBatch
            end
            args = struct(RecordBatchProxyID=recordBatch.Proxy.ID);
            obj.Proxy.writeBatch(args);
        end
    end
end