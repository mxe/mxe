/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 *
 * This is a simple test program for SDL_sound that tries to
 * decode the file specified as the only command-line argument.
 *
 * This file is in the Public Domain.
 */

#include <stdio.h>
#include <SDL_sound.h>

int main(int argc, char *argv[])
{
    if (argc != 2) {
        fprintf(stderr, "usage: %s <filename>\n", argv[0]);
        return 1;
    }

    if (SDL_Init(SDL_INIT_AUDIO) != 0) {
        fprintf(stderr, "Error: %s\n", SDL_GetError());
        return 1;
    }

    if (Sound_Init() == 0) {
        fprintf(stderr, "Error: %s\n", Sound_GetError());
        return 1;
    }

    SDL_RWops* rw = SDL_RWFromFile(argv[1], "r");
    if (rw == NULL) {
        fprintf(stderr, "Error: %s\n", SDL_GetError());
        return 1;
    }

    Sound_AudioInfo wantedFormat;
    wantedFormat.channels = 2;
    wantedFormat.rate = 44100;
    wantedFormat.format = AUDIO_S16LSB;

    Sound_Sample* sample = Sound_NewSample(rw, 0, &wantedFormat, 8192);
    if (sample == 0) {
        fprintf(stderr, "Error: %s\n", Sound_GetError());
        return 1;
    }

    Sound_DecodeAll(sample);
    printf("Format: %s\n", sample->decoder->description);
    printf("Decoded %d bytes of data.\n", sample->buffer_size);
    Sound_FreeSample(sample);

    return 0;
}
