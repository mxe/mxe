/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <stdio.h>
#include <windows.h>
#include <jpeglib.h>

int main(int argc, char *argv[])
{
    boolean test_boolean;
    INT32 test_int32;
    struct jpeg_decompress_struct cinfo;

    (void)argc;
    (void)argv;

    test_boolean = TRUE;
    test_int32 = 1;
    (void)test_boolean;
    (void)test_int32;

    jpeg_create_decompress(&cinfo);
    jpeg_destroy_decompress(&cinfo);

    return 0;
}
