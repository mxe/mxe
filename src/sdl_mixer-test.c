/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <SDL_mixer.h>

int main(int argc, char *argv[])
{
    int initted;

    (void)argc;
    (void)argv;

    initted = Mix_Init(MIX_INIT_FLAC | MIX_INIT_OGG | MIX_INIT_MOD);
    (void)initted;
    Mix_Quit();
    return 0;
}
