/* This file is part of mingw-cross-env.       */
/* See doc/index.html for further information. */

#include <librsvg/rsvg.h>

int main(int argc, char *argv[])
{
    RsvgHandle* handle;

    (void)argc;
    (void)argv;

    g_type_init();
    handle = rsvg_handle_new();
    rsvg_handle_free(handle);

    return 0;
}
