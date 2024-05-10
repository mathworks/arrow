function pyarrowArray = mlarrow2pyarrow(mlarrowArray)
    folder = fileparts(mfilename("fullpath"));
    
    [cArrayWrapper, cSchemaWrapper] = pyrunfile(fullfile(folder, "+internal/FFIWrapper.py"), ["cArrayWrapper" "cSchemaWrapper"]);

    cArrayAddress = uint64(cArrayWrapper.getAddress());
    cSchemaAdress = uint64(cSchemaWrapper.getAddress());

    mlarrowArray.exportToC(cArrayAddress, cSchemaAdress);

    if isa(mlarrowArray, "arrow.array.Array")
        dummyArray = py.pyarrow.array([1 2]);
        importFunc = py.getattr(dummyArray, "_import_from_c");
        pyarrowArray = importFunc(cArrayAddress, cSchemaAdress);
    else
        dummyArray = py.pyarrow.array([1 2]);
        dummyRB = py.pyarrow.record_batch(py.list({dummyArray}), names={'Var1'});
        importFunc = py.getattr(dummyRB, "_import_from_c");
        pyarrowArray = importFunc(cArrayAddress, cSchemaAdress);
    end
end

