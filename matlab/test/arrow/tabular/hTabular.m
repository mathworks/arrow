% Shared tests for Arrow tabular types (i.e. arrow.tabular.RecordBatch and
% arrow.tabular.Table).

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

classdef hTabular < matlab.unittest.TestCase

    properties (Abstract)

        TabularClassName (1, 1) string
        TabularConstructionFunction (1, 1) function_handle

    end

    properties

        MatlabTableBasic = table(...
            [1; 2; 3], ...
            ["A"; "B"; "C"], ...
            [true; false; true] ...
        )

    end

    methods (Test)

        function ConstructionFunction(testCase)
            % Verify that an instance of a tabular type can be created
            % from a MATLAB table using the construction function for the
            % tabular type.
            arrowTable = testCase.TabularConstructionFunction(testCase.MatlabTableBasic);
            testCase.verifyInstanceOf(arrowTable, testCase.TabularClassName);
        end

    end

end
