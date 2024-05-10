function pyarrowArray = mlarrow2pyarrow(mlarrowArray)
    [cArrayWrapper, cSchemaWrapper] = pyrunfile(fullfile(pwd, "+internal/FFIWrapper.py"), ["cArrayWrapper" "cSchemaWrapper"]);

    cArrayAddress = uint64(cArrayWrapper.getAddress());
    cSchemaAdress = uint64(cSchemaWrapper.getAddress());

    mlarrowArray.exportToC(cArrayAddress, cSchemaAdress);

    dummyArray = py.pyarrow.array([1 2]);
    importFunc = py.getattr(dummyArray, "_import_from_c");
    pyarrowArray = importFunc(cArrayAddress, cSchemaAdress);
end

