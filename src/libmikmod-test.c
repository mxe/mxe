/* This file is part of mingw-cross-env.       */
/* See doc/index.html for further information. */

#include <mikmod.h>

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    MikMod_RegisterAllDrivers();
    MikMod_Init("");

    MikMod_Exit();
    return 0;
}
