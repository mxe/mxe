/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

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
