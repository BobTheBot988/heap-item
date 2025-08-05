from setuptools import setup
from Cython.Build import cythonize

setup(
    ext_modules = cythonize("heapitem.pyx", language_level=3,
    compiler_directives={'boundscheck': False, 'wraparound': False})
)
