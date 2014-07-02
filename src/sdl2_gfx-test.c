/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <SDL.h>
#include <SDL2_rotozoom.h>
#include <SDL2_framerate.h>

int main(int argc, char* argv[])
{
    FPSmanager framerate_manager;

    (void)argc;
    (void)argv;

    if (SDL_Init(SDL_INIT_EVERYTHING) < 0) return 1;

    SDL_initFramerate(&framerate_manager);
    SDL_setFramerate(&framerate_manager, 60);
    SDL_framerateDelay(&framerate_manager);

    SDL_Quit();
    return 0;
}
