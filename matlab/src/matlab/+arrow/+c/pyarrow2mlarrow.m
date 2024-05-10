function mlarrowArray = pyarrow2mlarrow(pyarrowArray)
    cArray = arrow.c.ArrayCStruct;
    cSchema = arrow.c.SchemaCStruct;

    exportFunc = py.getattr(pyarrowArray, "_export_to_c");
    exportFunc(cArray.Address, cSchema.Address);

    mlarrowArray = arrow.array.Array.importFromC(cArray, cSchema);

end