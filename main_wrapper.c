// main_wrapper.c
#include <Python.h>
#include <locale.h>
#include <stdlib.h>
#include <stdio.h>
#include <limits.h>
#include <errno.h>

#ifdef WIN32
    #define realpath(N,R) _fullpath((R),(N),PATH_MAX)
#endif

// Declare the PyInit functions for our modules
PyMODINIT_FUNC PyInit_cqlsh_main(void);

int main(int argc, char *argv[]) {
    setlocale(LC_ALL, "C.UTF-8");
    // Register our module
    PyImport_AppendInittab("cqlsh_main", PyInit_cqlsh_main);

    // Initialize Python
    Py_Initialize();
    
    // Add current directory to Python path
    //PyRun_SimpleString("import sys; sys.path.insert(0, '.')");

    char full_path[PATH_MAX];
    if (realpath(argv[0], full_path) == NULL) {
        perror("Error resolving full path");
        return 1;
    }
    char full_lib_path[PATH_MAX];
#ifndef LIB_DIR
#ifdef WIN32
    snprintf(full_lib_path, sizeof(full_lib_path), "%s\\..\\Lib", full_path);
#else
    snprintf(full_lib_path, sizeof(full_lib_path), "%s/../lib", full_path);
#endif
#else
    snprintf(full_lib_path, sizeof(full_lib_path), "%s", LIB_DIR);
#endif
    char python_code[PATH_MAX + 50]; // Increased buffer size for Python code
    snprintf(python_code, sizeof(python_code), "import sys; sys.path.insert(0, '%s')", full_lib_path);
    PyRun_SimpleString(python_code);

    // Create argument list
    PyObject *cmdline = PyList_New(argc-1);
    for(int i=1; i<argc; i++) {
        PyList_SET_ITEM(cmdline, i-1, PyUnicode_FromString(argv[i]));
    }

    // Create package path (adjust path as needed)
    PyObject *pkgpath = PyUnicode_FromString("cassandra");

    // Create arguments tuple
    PyObject *args = PyTuple_Pack(2, cmdline, pkgpath);
    
    // Import our main module
    PyObject *module = PyImport_ImportModule("cqlsh_main");
    if (module == NULL) {
        PyErr_Print();
        return 1;
    }

    // Call the main function
    PyObject *func = PyObject_GetAttrString(module, "main");
    PyObject *result = PyObject_CallObject(func, args);

    // Check for errors
    if (PyErr_Occurred()) {
        PyErr_Print();
        return 1;
    }

    // Extract exit code
    int exit_code = 0;
    if (result != NULL && PyLong_Check(result)) {
        exit_code = (int)PyLong_AsLong(result);
    }

    // Clean up
    Py_XDECREF(result);
    Py_XDECREF(func);
    Py_XDECREF(module);
    Py_Finalize();

    return exit_code;
}