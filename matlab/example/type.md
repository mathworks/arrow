### Arrow `Type` classes (i.e. `arrow.type.<Type>`)

#### Create an Arrow `Int8Type` object

```matlab
>> type = arrow.int8()

type =

  Int8Type with properties:

    ID: Int8
```

#### Create an Arrow `TimestampType` object with a specific `TimeUnit` and `TimeZone`

```matlab
>> type = arrow.timestamp(TimeUnit="Second", TimeZone="Asia/Kolkata")

type =

  TimestampType with properties:

          ID: Timestamp
    TimeUnit: Second
    TimeZone: "Asia/Kolkata"
```


#### Get the type enumeration `ID` for an Arrow `Type` object

```matlab
>> type.ID

ans =

  ID enumeration

    Timestamp

>> type = arrow.string()

type =

  StringType with properties:

    ID: String

>> type.ID

ans =

  ID enumeration

    String
```
