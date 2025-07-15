### Arrow `RecordBatch` class

#### Create an Arrow `RecordBatch` from a MATLAB `table`

```matlab
>> matlabTable = table(["A"; "B"; "C"], [1; 2; 3], [true; false; true])

matlabTable =

  3x3 table

    Var1    Var2    Var3
    ____    ____    _____

    "A"      1      true
    "B"      2      false
    "C"      3      true

>> arrowRecordBatch = arrow.recordBatch(matlabTable)

arrowRecordBatch = 

  Arrow RecordBatch with 3 rows and 3 columns:

    Schema:

        Var1: String | Var2: Float64 | Var3: Boolean

    First Row:

        "A" | 1 | true
```

#### Create a MATLAB `table` from an Arrow `RecordBatch`

```matlab
>> arrowRecordBatch

arrowRecordBatch = 

  Arrow RecordBatch with 3 rows and 3 columns:

    Schema:

        Var1: String | Var2: Float64 | Var3: Boolean

    First Row:

        "A" | 1 | true

>> matlabTable = table(arrowRecordBatch)

matlabTable =

  3x3 table

    Var1    Var2    Var3
    ____    ____    _____

    "A"      1      true
    "B"      2      false
    "C"      3      true
```

#### Create an Arrow `RecordBatch` from multiple Arrow `Array`s


```matlab
>> stringArray = arrow.array(["A", "B", "C"])

stringArray = 

  StringArray with 3 elements and 0 null values:

    "A" | "B" | "C"

>> timestampArray = arrow.array([datetime(1997, 01, 01), datetime(1998, 01, 01), datetime(1999, 01, 01)])

timestampArray = 

  TimestampArray with 3 elements and 0 null values:

    1997-01-01 00:00:00.000000 | 1998-01-01 00:00:00.000000 | 1999-01-01 00:00:00.000000

>> booleanArray = arrow.array([true, false, true])

booleanArray = 

  BooleanArray with 3 elements and 0 null values:

    true | false | true

>> arrowRecordBatch = arrow.tabular.RecordBatch.fromArrays(stringArray, timestampArray, booleanArray)

arrowRecordBatch = 

  Arrow RecordBatch with 3 rows and 3 columns:

    Schema:

        Column1: String | Column2: Timestamp | Column3: Boolean

    First Row:

        "A" | 1997-01-01 00:00:00.000000 | true
```

#### Extract a column from a `RecordBatch` by index

```matlab
>> arrowRecordBatch = arrow.tabular.RecordBatch.fromArrays(stringArray, timestampArray, booleanArray)

arrowRecordBatch = 

  Arrow RecordBatch with 3 rows and 3 columns:

    Schema:

        Column1: String | Column2: Timestamp | Column3: Boolean

    First Row:

        "A" | 1997-01-01 00:00:00.000000 | true

>> timestampArray = arrowRecordBatch.column(2)

timestampArray = 

  TimestampArray with 3 elements and 0 null values:

    1997-01-01 00:00:00.000000 | 1998-01-01 00:00:00.000000 | 1999-01-01 00:00:00.000000
```
