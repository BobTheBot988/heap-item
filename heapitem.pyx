# distutils: language = c++

from libc.string cimport strncpy, strlen
from cpython.bytes cimport PyBytes_FromStringAndSize
from cpython.mem cimport PyMem_Malloc,PyMem_Free


cdef class HeapItem:
    cdef double _prob
    cdef char* _string

    def __cinit__(self, double probability, string:str):
        size_t length = len(string)

        if isinstance(string,str):
           string_bytes:bytes = (<str>string).encode('ascii')
           self._string = <char*>PyMem_Malloc(length+1)
           if self._string == NULL:
               raise MemoryError("Failed to allocate string buffer")
           
           strncpy(self._string, string_bytes, length)
           self._string[length] = b'\0' # Ensure null byte for security purposes  this should be equivalent to strncpy_s
        else:
            raise TypeError("The string must be of string type")

        if isinstance(probability,float):   
            self._prob = <double>probability
        else: 
            raise TypeError("The Probability must be a float")

    def free(self):
         if self._string != NULL:
            PyMem_Free(self._string)
            self._string = NULL

    def __dealloc__(self):
        if self._string != NULL:
            PyMem_Free(self._string)                                        
                    
    def __lt__(self, HeapItem other)->bool:
        return self._prob < other._prob

    def __eq__(self, HeapItem other)->bool:
        return self._prob == other._prob and self.string_string == other.string_string

    # We need to add THE GC overhead
    def memory_size(self) -> dict[str[int]]:
        """Return detailed breakdown of memory usage"""
        return {
            'object_size': sizeof(HeapItem),
            'string_buffer': sizeof(char) * (strlen(self._string)+1) if self._string != NULL else 0,
            'total': sizeof(HeapItem) + (sizeof(char) * (strlen(self._string)+ 1) if self._string != NULL else 0)
        }

    def __sizeof__(self)->int:
        return self.memory_size()['total']

    @property
    def string_string(self)->str:
        return (<bytes>PyBytes_FromStringAndSize(self._string, strlen(self._string))).decode('ascii') 

    @property
    def prob(self):
        return self._prob

    @prob.setter
    def prob(self, val):
        self._prob = val
   
    def __repr__(self)->str:
        return f"({self.prob}, {self.string_string})"
