### Feather V1

#### Write a MATLAB table to a Feather V1 file

``` matlab
>> t = table(["A"; "B"; "C"], [1; 2; 3], [true; false; true])

t =

  3×3 table

    Var1    Var2    Var3
    ____    ____    _____

    "A"      1      true
    "B"      2      false
    "C"      3      true

>> filename = "table.feather";

>> featherwrite(filename, t)
```

#### Read a Feather V1 file into a MATLAB table

``` matlab
>> filename = "table.feather";

>> t = featherread(filename)

t =

  3×3 table

    Var1    Var2    Var3
    ____    ____    _____

    "A"      1      true
    "B"      2      false
    "C"      3      true
```
