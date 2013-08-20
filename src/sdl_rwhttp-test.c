/*
 * This file is part of MXE.
 * See index.html for further information.
 *
 * This is a simple test program for SDL_rwhttp that tries to
 * fetch something from the web.
 *
 * This file is in the Public Domain.
 */

#include <stdio.h>
#include <SDL_rwhttp.h>

int main(int argc, char *argv[])
{
    int ret = EXIT_SUCCESS;
    const char *url;
    SDL_RWops* rwops;

    if (argc != 2) {
        fprintf(stderr, "usage: %s <url>\n", argv[0]);
        return EXIT_FAILURE;
    }

    url = argv[1];

    if (SDL_RWHttpInit() == -1) {
        fprintf(stderr, "%s\n", SDL_GetError());
        return EXIT_FAILURE;
    }

    rwops = SDL_RWFromHttpSync(url);
    if (!rwops) {
        fprintf(stderr, "%s\n", SDL_GetError());
        ret = EXIT_FAILURE;
    } else {
        printf("success\n");
        SDL_RWclose(rwops);
    }

    if (SDL_RWHttpShutdown() == -1) {
        fprintf(stderr, "%s\n", SDL_GetError());
        return EXIT_FAILURE;
    }
    return ret;
}
