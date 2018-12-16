#include <Python.h>

/*
 * Implements an example function.
 */
PyDoc_STRVAR(umkehr_if_example_doc, "example(obj, number)\
\
Example function");

PyObject *umkehr_if_example(PyObject *self, PyObject *args, PyObject *kwargs) {
    /* Shared references that do not need Py_DECREF before returning. */
    PyObject *obj = NULL;
    int number = 0;

    /* Parse positional and keyword arguments */
    static char* keywords[] = { "obj", "number", NULL };
    if (!PyArg_ParseTupleAndKeywords(args, kwargs, "Oi", keywords, &obj, &number)) {
        return NULL;
    }

    /* Function implementation starts here */

    if (number < 0) {
        PyErr_SetObject(PyExc_ValueError, obj);
        return NULL;    /* return NULL indicates error */
    }

    Py_RETURN_NONE;
}

/*
 * List of functions to add to umkehr_if in exec_umkehr_if().
 */
static PyMethodDef umkehr_if_functions[] = {
    { "example", (PyCFunction)umkehr_if_example, METH_VARARGS | METH_KEYWORDS, umkehr_if_example_doc },
    { NULL, NULL, 0, NULL } /* marks end of array */
};

/*
 * Initialize umkehr_if. May be called multiple times, so avoid
 * using static state.
 */
int exec_umkehr_if(PyObject *module) {
    PyModule_AddFunctions(module, umkehr_if_functions);

    PyModule_AddStringConstant(module, "__author__", "nickl");
    PyModule_AddStringConstant(module, "__version__", "1.0.0");
    PyModule_AddIntConstant(module, "year", 2018);

    return 0; /* success */
}

/*
 * Documentation for umkehr_if.
 */
PyDoc_STRVAR(umkehr_if_doc, "The umkehr_if module");


static PyModuleDef_Slot umkehr_if_slots[] = {
    { Py_mod_exec, exec_umkehr_if },
    { 0, NULL }
};

static PyModuleDef umkehr_if_def = {
    PyModuleDef_HEAD_INIT,
    "umkehr_if",
    umkehr_if_doc,
    0,              /* m_size */
    NULL,           /* m_methods */
    umkehr_if_slots,
    NULL,           /* m_traverse */
    NULL,           /* m_clear */
    NULL,           /* m_free */
};

PyMODINIT_FUNC PyInit_umkehr_if() {
    return PyModuleDef_Init(&umkehr_if_def);
}
