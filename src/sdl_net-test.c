/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <SDL_net.h>

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    if (SDL_Init(SDL_INIT_EVERYTHING) < 0) return 1;
    if (SDLNet_Init() < 0) return 1;

    SDLNet_Quit();
    SDL_Quit();
    return 0;
}
