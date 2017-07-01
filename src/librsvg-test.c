/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <librsvg/rsvg.h>

int main(int argc, char *argv[])
{
    RsvgHandle* handle;

    (void)argc;
    (void)argv;

    g_type_init();
    handle = rsvg_handle_new();
    g_object_unref(handle);

    return 0;
}
