### Arrow `Field` class

#### Create an Arrow `Field` with type `Int8Type`

```matlab
>> field = arrow.field("Number", arrow.int8())

field = 

  Field with properties:

    Name: "Number"
    Type: [1x1 arrow.type.Int8Type]

>> field.Name

ans =

    "Number"

>> field.Type

ans =

  Int8Type with properties:

    ID: Int8

```

#### Create an Arrow `Field` with type `StringType`

```matlab
>> field = arrow.field("Letter", arrow.string())

field = 

  Field with properties:

    Name: "Letter"
    Type: [1x1 arrow.type.StringType]

>> field.Name

ans =

    "Letter"

>> field.Type

ans =

  StringType with properties:

    ID: String
```

#### Extract an Arrow `Field` from an Arrow `Schema` by index

```matlab
>> arrowSchema

arrowSchema = 

  Arrow Schema with 2 fields:

    Letter: String | Number: Int8

% Specify the field to extract by its index (i.e. 2)
>> field = arrowSchema.field(2)

field = 

  Field with properties:

    Name: "Number"
    Type: [1x1 arrow.type.Int8Type]
```

#### Extract an Arrow `Field` from an Arrow `Schema` by name

```matlab
>> arrowSchema

arrowSchema = 

  Arrow Schema with 2 fields:

    Letter: String | Number: Int8

% Specify the field to extract by its name (i.e. "Letter")
>> field = arrowSchema.field("Letter")

field = 

  Field with properties:

    Name: "Letter"
    Type: [1x1 arrow.type.StringType]
```
