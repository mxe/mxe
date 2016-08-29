/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <libaacs/aacs.h>

int main (int argc, char **argv)
{
    int major, minor, micro;

    (void)argc;
    (void)argv;

    aacs_get_version(&major, &minor, &micro);

    return 0;
}
