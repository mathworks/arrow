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

classdef AbstractTestCasesForIndexing < matlab.unittest.TestCase
    % Test cases for arrow array indexing.
    % Tests here can be shared among different datatypes.

    properties(Abstract)
        arrowArrayForIndexingTests {mustBeLength10}
        correspondingMATLABArrayForIndexingTests(1,10)
    end
    
    methods(Test)
        function IndexIsANumericScalar(testCase)
            % Verify that the index used in indexing can be a numeric
            % scalar.
            testCase.assumeFail("Filter all indexing tests until indexing is supported");

            arrowArray = testCase.arrowArrayForIndexingTests;
            correspondingMATLABArray = testCase.correspondingMATLABArrayForIndexingTests;

            % Index is in numeric type "double"
            index = 3;
            out = arrowArray(index);

            testCase.verifyEqual(class(out), class(arrowArray));
            testCase.verifyEqual(out.toMATLAB(), correspondingMATLABArray(index));

            % Index is in integer type
            index = int8(3);
            out = arrowArray(index);

            testCase.verifyEqual(class(out), class(arrowArray));
            testCase.verifyEqual(out.toMATLAB(), correspondingMATLABArray(index));
        end

        function IndexIsAVector(testCase)
            % Verify that the output's orientation doesn't change based on 
            % the orientation of input indicies vector.
            testCase.assumeFail("Filter all indexing tests until indexing is supported");

            arrowArray = testCase.arrowArrayForIndexingTests;
            correspondingMATLABArray = testCase.correspondingMATLABArrayForIndexingTests;

            % Index is a row vector.
            indices = single([2, 3, 4]);
            out = arrowArray(indices);

            testCase.verifyEqual(class(out), class(arrowArray));
            testCase.verifyEqual(out.toMATLAB(), correspondingMATLABArray(indices)');

            % Index is a column vector.
            indices = uint64([4; 5; 6]);
            out = arrowArray(indices);

            testCase.verifyEqual(class(out), class(arrowArray));
            testCase.verifyEqual(out.toMATLAB(), correspondingMATLABArray(indices)');
        end

        function IndexMustBeContinuousInterval(testCase)
            % Verify that the indices must be one continuous interval.
            testCase.assumeFail("Filter all indexing tests until indexing is supported");

            arrowArray = testCase.arrowArrayForIndexingTests;
            correspondingMATLABArray = testCase.correspondingMATLABArrayForIndexingTests;

            % Ok: One continuous interval
            indices = 1:5;
            out = arrowArray(indices);

            testCase.verifyEqual(class(out), class(arrowArray));
            testCase.verifyEqual(out.toMATLAB(), correspondingMATLABArray(indices)');

            % Error: two continuous intervals
            indices = [1:4, 6:9];
            testCase.verifyError(@()arrowArray(indices), 'errorID');

            % Error: discontinuous interval
            indices = [1, 3, 5, 7, 9];
            testCase.verifyError(@()arrowArray(indices), 'errorID');
        end

        function IndexCanBeEmpty(testCase)
            % Verify that the index used in arrow array can be empty.
            testCase.assumeFail("Filter all indexing tests until indexing is supported");

            arrowArray = testCase.arrowArrayForIndexingTests;

            % 0-by-0 empty
            index = [];
            out = arrowArray(index);

            testCase.verifyEqual(class(out), class(arrowArray));
            testCase.verifyEqual(out.NumElements, 0);

            % 1-by-0 empty
            index = double.empty(1, 0);
            out = arrowArray(index);

            testCase.verifyEqual(class(out), class(arrowArray));
            testCase.verifyEqual(out.NumElements, 0);

            % 0-by-1 empty
            index = double.empty(0, 1);
            out = arrowArray(index);

            testCase.verifyEqual(class(out), class(arrowArray));
            testCase.verifyEqual(out.NumElements, 0);
        end

        function IndexIsOutOfBound(testCase)
            % Verify that index must be within the range of 
            % [1, arrayLength]. arrow.array indexing uses 1-based indexing 
            % to be consistent with MATLAB behavior.
            testCase.assumeFail("Filter all indexing tests until indexing is supported");

            arrowArray = testCase.arrowArrayForIndexingTests;

            % Error: Index = 0;
            index = 0;
            testCase.verifyError(@()arrowArray(index), 'errorID');

            % Error: Index = array_length + 1
            index = arrowArray.NumElements + 1;
            testCase.verifyError(@()arrowArray(index), 'errorID');

            % Error: Indicies contains index value that is out of range [1, arrayLength]
            index = 0 : (arrowArray.NumElements + 5);
            testCase.verifyError(@()arrowArray(index), 'errorID');
        end

        function IndexIsInvalid(testCase)
            % Verify that the index used in indexing must be positive
            % integer values.
            testCase.assumeFail("Filter all indexing tests until indexing is supported");

            arrowArray = testCase.arrowArrayForIndexingTests;

            % Error: Index is a float number
            index = 1.1;
            testCase.verifyError(@()arrowArray(index), 'errorID');

            % Error: Index is a negative integer
            index = -1;
            testCase.verifyError(@()arrowArray(index), 'errorID');

            % Error: Index is a complex number
            index = 1+1i;
            testCase.verifyError(@()arrowArray(index), 'errorID');
        end

        function IndexCannotContainDuplicatedValue(testCase)
            % Verify that the index cannot contain duplicated values.
            testCase.assumeFail("Filter all indexing tests until indexing is supported");

            arrowArray = testCase.arrowArrayForIndexingTests;

            index = [1, 2, 3, 2, 5];
            testCase.verifyError(@()arrowArray(index), 'errorID');
        end

        function NotSupportLogicalAsIndex(testCase)
            % Verify that using logical values as indices is not supported
            % yet.
            testCase.assumeFail("Filter all indexing tests until indexing is supported");

            arrowArray = testCase.arrowArrayForIndexingTests;

            % Index = true. This case is used to verify whether arrowArray
            % returns its first element or errors due to size mismatch.
            index = true;
            testCase.verifyError(@()arrowArray(index), 'errorID');

            % Index is a logical vector with the same length as the arrow
            % array.
            index = [false, true(1, arrowArray.NumElements-3), false, true];
            testCase.verifyError(@()arrowArray(index), 'errorID');

            % length(index) is longer than arrowArray.NumElements, but the
            % trailing elements of index that exceeds the arrowArray length
            % are all false.
            index = [true(1, arrowArray.NumElements), false, false];
            testCase.verifyError(@()arrowArray(index), 'errorID');
        end

        function UnsupportedIndexSyntax(testCase)
            % Verify that indexing syntax other than a(i) is not supported.
            testCase.assumeFail("Filter all indexing tests until indexing is supported");

            arrowArray = testCase.arrowArrayForIndexingTests;

            % a{i}
            testCase.verifyError(@()arrowArray{1}, 'errorID');

            % a(i,j)
            testCase.verifyError(@()arrowArray(1,2), 'errorID');
        end
    end
end

function mustBeLength10(a)
    if a.NumElements ~= 10
        error("Test cases in 'AbstractTestCasesForIndexing' require " + ...
              "the tested arrow array 'arrowArrayForIndexingTests' contain 10 elements");
    end
end