/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <stdio.h>
#include <ffi.h>

int main(int argc, char *argv[])
{
    ffi_cif cif;
    ffi_type *args[1];
    void *values[1];
    char *s;
    int rc;

    (void)argc;
    (void)argv;

    args[0] = &ffi_type_pointer;
    values[0] = &s;

    if (ffi_prep_cif(&cif, FFI_DEFAULT_ABI, 1,
                           &ffi_type_uint, args) == FFI_OK)
    {
        s = "Hello World!";
        ffi_call(&cif, FFI_FN(puts), &rc, values);
        s = "Goodbye!";
        ffi_call(&cif, FFI_FN(puts), &rc, values);
    }

    return 0;
}
