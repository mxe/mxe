/*
 * This file is part of MXE.
 * See index.html for further information.
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
