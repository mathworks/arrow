### Arrow `Schema` class

#### Create an Arrow `Schema` from multiple Arrow `Field`s

```matlab
>> letter = arrow.field("Letter", arrow.string())

letter = 

  Field with properties:

    Name: "Letter"
    Type: [1x1 arrow.type.StringType]

>> number = arrow.field("Number", arrow.int8())

number = 

  Field with properties:

    Name: "Number"
    Type: [1x1 arrow.type.Int8Type]

>> schema = arrow.schema([letter, number])

schema = 

  Arrow Schema with 2 fields:

    Letter: String | Number: Int8
```

#### Get the `Schema` of an Arrow `RecordBatch`

```matlab
>> matlabTable = table(["A"; "B"; "C"], [1; 2; 3], VariableNames=["Letter", "Number"])

matlabTable =

  3x2 table

    Letter    Number
    ______    ______

     "A"        1
     "B"        2
     "C"        3

>> arrowRecordBatch = arrow.recordBatch(matlabTable)

arrowRecordBatch = 

  Arrow RecordBatch with 3 rows and 2 columns:

    Schema:

        Letter: String | Number: Float64

    First Row:

        "A" | 1

>> arrowSchema = arrowRecordBatch.Schema

arrowSchema = 

  Arrow Schema with 2 fields:

    Letter: String | Number: Float64
```
