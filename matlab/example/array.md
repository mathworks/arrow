### Arrow `Array` classes (i.e. `arrow.array.<Array>`)

#### Create an Arrow `Float64Array` from a MATLAB `double` array

```matlab
>> matlabArray = double([1, 2, 3])

matlabArray =

     1     2     3

>> arrowArray = arrow.array(matlabArray)

arrowArray = 

  Float64Array with 3 elements and 0 null values:

    1 | 2 | 3
```

#### Create a MATLAB `logical` array from an Arrow `BooleanArray`

```matlab
>> arrowArray = arrow.array([true, false, true])

arrowArray = 

  BooleanArray with 3 elements and 0 null values:

    true | false | true

>> matlabArray = toMATLAB(arrowArray)

matlabArray =

  3×1 logical array

   1
   0
   1
```

#### Specify `Null` Values when constructing an `arrow.array.Int8Array`

```matlab
>> matlabArray = int8([122, -1, 456, -10, 789])

matlabArray =

  1×5 int8 row vector

    122     -1    127    -10    127

% Treat all negative array elements as Null
>> validElements = matlabArray > 0

validElements =

  1×5 logical array

   1   0   1   0   1

% Specify which values are Null/Valid by supplying a logical validity "mask"
>> arrowArray = arrow.array(matlabArray, Valid=validElements)

arrowArray = 

  Int8Array with 5 elements and 2 null values:

    122 | null | 127 | null | 127
```
