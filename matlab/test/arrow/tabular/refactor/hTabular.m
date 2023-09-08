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
        TabularFromArraysFunction (1, 1) function_handle

    end

    properties (TestParameter)

        MatlabConversionFunction = {@toMATLAB, @table};
        NumColumns = num2cell(int32([0, 1, 2, 5, 10, 100]));
        ColumnNames = { ["X", "Y", "Z"], ["😀", "🌲", "🥭"], ["", " ", ""]};
        ArrowArrays = {arrow.array([1, 2, 3]), arrow.array(["A", "B", "C"]), arrow.array([true, false, true])}
        MatlabTableEmptyNoColumns = { table.empty(0, 0), table.empty(1, 0) };
    end

    properties

        MatlabTableEmptyNoRows = table.empty(0, 1);
        MatlabTableAllTypes = arrow.internal.test.tabular.createTableWithSupportedTypes()
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
            arrowTabularType = testCase.TabularConstructionFunction(testCase.MatlabTableBasic);
            testCase.verifyInstanceOf(arrowTabularType, testCase.TabularClassName);
        end

        function RoundTripMatlabTable(testCase, MatlabConversionFunction)
            % Verify that a MATLAB table containing all types
            % supported for conversion to Arrow Arrays can be round-tripped
            % from an Arrow tabular type to a MATLAB table and back.
            % Verify that a MATLAB table containing all types supported
            % for conversion to Arrow Arrays can be round-tripped
            % to an Arrow tabular type and back as expected using
            % a combination of the tabular type construction function
            % and one of the MATLAB conversion functions (i.e. toMATLAB
            % or table).
            expectedMatlabTable = testCase.MatlabTableAllTypes;
            arrowTabularType = testCase.TabularConstructionFunction(expectedMatlabTable);
            actualMatlabTable = MatlabConversionFunction(arrowTabularType);
            testCase.verifyEqual(actualMatlabTable, expectedMatlabTable);
        end

        function PropertyNumColumns(testCase, NumColumns)
            % Verify that the NumColumns property of an Arrow tabular type
            % returns the expected number of columns.
            matlabTable = array2table(ones(1, NumColumns));
            arrowTabularType = testCase.TabularConstructionFunction(matlabTable);
            testCase.verifyEqual(arrowTabularType.NumColumns, NumColumns);
        end

        function PropertyColumnNames(testCase, ColumnNames)
            % Verify that the ColumnNames property of an Arrow tabular type
            % returns the expected string array of column names.\
            arrowTabularType = testCase.TabularFromArraysFunction(testCase.ArrowArrays{:}, ColumnNames=ColumnNames);
            testCase.verifyEqual(arrowTabularType.ColumnNames, ColumnNames);
        end

        function ConstructionFunctionEmptyTableNoColumns(testCase, MatlabTableEmptyNoColumns)
            % Verify that an Arrow tabular type can be created from an
            % empty MATLAB table with no columns (i.e. 0x0 and 1x0) using
            % the tabular type's associated construction function.
            expectedArrowTabularType = testCase.makeEmptyNoColumnsArrowTabularType();
            actualArrowTabularType = testCase.TabularConstructionFunction(MatlabTableEmptyNoColumns);
            testCase.verifyEqual(actualArrowTabularType, expectedArrowTabularType);
        end

        function ConstructionFunctionEmptyTableNoRows(testCase)
            % Verify that an Arrow tabular type can be created from an
            % empty MATLAB table with no rows (i.e. 0x1) using the tabular
            % type's associated construction function.
            expected = testCase.makeEmptyNoRowsArrowTabularType();
            actual = testCase.TabularConstructionFunction(testCase.MatlabTableEmptyNoRows);
            testCase.verifyEqual(actual, expected);
        end

        function ColumnNumericIndexWithEmptyTabularTypeError(testCase)
            % Verify that an arrow:tabular:indexing:NumericIndexWithEmptyTabularType
            % error is thrown when calling the column(index) method on an empty
            % Arrow tabular type with no columns (i.e. 0x0 and 1x0).
            arrowTabularType = testCase.makeEmptyNoColumnsArrowTabularType();
            fcn = @() arrowTabularType.column(1);
            testCase.verifyError(fcn, "arrow:tabular:indexing:NumericIndexWithEmptyTabularType");
        end

        function ColumnInvalidNumericColumnIndexError(testCase)
            % Verify that an arrow:tabular:indexing:InvalidNumericColumnIndex
            % error is thrown when a numeric index value is provided to the
            % column(index) method that is outside the range of valid column
            % indices (e.g. greater than the number of columns).
            matlabTable = testCase.MatlabTableBasic;
            arrowTabularType = testCase.TabularConstructionFunction(matlabTable);
            fcn = @() arrowTabularType.column(4);
            testCase.verifyError(fcn, "arrow:tabular:indexing:InvalidNumericColumnIndex");
        end

    end

    methods

        function arrowTabularType = makeEmptyNoColumnsArrowTabularType(testCase)
            arrowTabularType = testCase.TabularFromArraysFunction();
        end

        function arrowTabularType = makeEmptyNoRowsArrowTabularType(testCase)
            arrowTabularType = testCase.TabularFromArraysFunction(arrow.array([]), ColumnNames="Var1");
        end

    end

end
