/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <libmodplug/modplug.h>

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    ModPlug_Settings settings;
    ModPlug_GetSettings(&settings);
    ModPlug_SetSettings(&settings);
    return 0;
}
