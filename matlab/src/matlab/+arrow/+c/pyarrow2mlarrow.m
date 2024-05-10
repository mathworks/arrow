function mlarrowArray = pyarrow2mlarrow(pyarrowArray)
    cArray = arrow.c.ArrayCStruct;
    cSchema = arrow.c.SchemaCStruct;

    exportFunc = py.getattr(pyarrowArray, "_export_to_c");
    exportFunc(cArray.Address, cSchema.Address);

    if isa(pyarrowArray, "py.pyarrow.lib.Array")
        mlarrowArray = arrow.array.Array.importFromC(cArray, cSchema);
    else
        importer = arrow.c.internal.RecordBatchImporter();
        mlarrowArray = importer.import(cArray, cSchema);
    end
end