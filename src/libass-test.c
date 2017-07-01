/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <ass/ass.h>

int main(int argc, char *argv[])
{
    ASS_Library *handle;

    (void)argc;
    (void)argv;

    handle = ass_library_init();
    ass_library_done(handle);

    return 0;
}
