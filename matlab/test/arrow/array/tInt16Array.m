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

classdef tInt16Array < hNumericArray & ...
                       AbstractTestCasesForIndexing
% Tests for arrow.array.Int16Array
    
    properties
        ArrowArrayClassName = "arrow.array.Int16Array"
        ArrowArrayConstructorFcn = @arrow.array.Int16Array.fromMATLAB
        MatlabConversionFcn = @int16 % int16 method on class
        MatlabArrayFcn = @int16 % int16 function
        MaxValue = intmax("int16")
        MinValue = intmin("int16")
        NullSubstitutionValue = int16(0)
        ArrowType = arrow.int16
    end

    properties
        % Properties required by 'AbstractTestCasesForIndexing'
        correspondingMATLABArrayForIndexingTests = int16([0, intmax("int16"), 0, intmin("int16"), 100, -128, intmin("int16"), 127, intmax("int16"), -50]);
        arrowArrayForIndexingTests = arrow.array.Int16Array.fromMATLAB(...
                                                   int16([0, intmax("int16"), 0, intmin("int16"), 100, -128, intmin("int16"), 127, intmax("int16"), -50]));
    end
end
