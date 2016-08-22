/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <SDL.h>
#include <SDL_image.h>

int main(int argc, char *argv[])
{
    SDL_Surface *image;
    SDL_Surface *screen;

    (void)argc;
    (void)argv;

    if (SDL_Init(SDL_INIT_EVERYTHING) < 0) return 1;

    image = IMG_Load("test.png");
    screen = SDL_SetVideoMode(640, 480, 32, SDL_HWSURFACE);

    if (SDL_BlitSurface(image, NULL, screen, NULL) < 0) return 1;
    SDL_UpdateRect(screen, 0, 0, image->w, image->h);
    SDL_Delay(3000);
    SDL_Quit();
    return 0;
}
