/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <sox.h>

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    sox_format_init();
    return(0);
}
