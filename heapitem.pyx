# distutils: language = c++

from libc.string cimport strncpy, strlen
from cpython.bytes cimport PyBytes_FromStringAndSize
from cpython.mem cimport PyMem_Malloc,PyMem_Free


cdef class HeapItem:
    cdef double _prob
    cdef char* _password

    def __cinit__(self, double probability, password:str, unsigned length):
        if not (isinstance(length,int) and length > 0):
            raise TypeError("The len must be a positive integer")

        if isinstance(password,str):
           password_bytes:bytes = (<str>password).encode('ascii')
           self._password = <char*>PyMem_Malloc(length+1)
           if self._password == NULL:
               raise MemoryError("Failed to allocate password buffer")
           
           strncpy(self._password, password_bytes, length)
           self._password[length] = b'\0' # Ensure null byte for security purposes  this should be equivalent to strncpy_s
        else:
            raise TypeError("The password must be of string type")

        if isinstance(probability,float):   
            self._prob = <double>probability
        else: 
            raise TypeError("The Probability must be a float")

    def free(self):
         if self._password != NULL:
            PyMem_Free(self._password)
            self._password = NULL

    def __dealloc__(self):
        if self._password != NULL:
            PyMem_Free(self._password)                                        
                    
    def __lt__(self, HeapItem other)->bool:
        return self._prob < other._prob

    def __eq__(self, HeapItem other)->bool:
        return self._prob == other._prob and self.password_string == other.password_string
    
    def memory_size(self) -> dict[str[int]]:
        """Return detailed breakdown of memory usage"""
        return {
            'object_size': sizeof(HeapItem),
            'password_buffer': sizeof(char) * (strlen(self._password)+1) if self._password != NULL else 0,
            'total': sizeof(HeapItem) + (sizeof(char) * (strlen(self._password)+ 1) if self._password != NULL else 0)
        }

    def __sizeof__(self)->int:
        return self.memory_size()['total']

    @property
    def password_string(self)->str:
        return (<bytes>PyBytes_FromStringAndSize(self._password, strlen(self._password))).decode('ascii') 

    @property
    def prob(self):
        return self._prob

    @prob.setter
    def prob(self, val):
        self._prob = val
   
    def __repr__(self)->str:
        return f"({self.prob}, {self.password_string})"
