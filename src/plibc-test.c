/*
 * This file is part of MXE.
 * See index.html for further information.
 *
 */

#include "plibc.h"

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    plibc_init("MXE", "MXE");
    PRINTF("%s Test", "PlibC");
    plibc_shutdown();

    return 0;
}
