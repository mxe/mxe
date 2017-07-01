/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <smpeg.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
    SMPEG_version v;

    (void)argc;
    (void)argv;

    SMPEG_VERSION(&v);
    printf("SMPEG version: %d.%d.%d\n", v.major, v.minor, v.patch);

    return 0;
}
