/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <stdio.h>
#include <magic.h>

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    fprintf(stdout, "magic file from %s\n", magic_getpath(NULL, 0));
    return 0;
}
