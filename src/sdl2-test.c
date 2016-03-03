/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <SDL.h>

int main(int argc, char *argv[])
{
    SDL_Window* window = NULL;

    (void)argc;
    (void)argv;

    if (SDL_Init(SDL_INIT_VIDEO) < 0) return 1;

    window = SDL_CreateWindow("MXE test", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 640, 480, SDL_WINDOW_SHOWN);
    SDL_Delay(2000);
    SDL_DestroyWindow(window);
    SDL_Quit();
    return 0;
}
