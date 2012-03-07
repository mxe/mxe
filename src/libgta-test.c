/* This file is part of mingw-cross-env.       */
/* See doc/index.html for further information. */

#include <gta/gta.h>

int main(int argc, char *argv[])
{
    gta_header_t *header;
    gta_result_t r;

    (void)argc;
    (void)argv;

    r = gta_create_header(&header);
    if (r == GTA_OK) {
        gta_destroy_header(header);
    }

    return 0;
}
