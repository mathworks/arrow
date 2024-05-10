from pyarrow.cffi import ffi

class FFIWrapper:
    def __init__(self, cdata):
        self.cdata = cdata
    
    def getAddress(self):
        address = int(ffi.cast("uintptr_t", self.cdata))
        return address

cArray = ffi.new("struct ArrowArray*")
cSchema = ffi.new("struct ArrowSchema*")

cArrayWrapper = FFIWrapper(cArray)
cSchemaWrapper = FFIWrapper(cSchema)




