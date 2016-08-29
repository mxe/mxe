/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <AL/alc.h>

int main(int argc, char **argv)
{
    ALCdevice *dev;
    ALCcontext *ctx;

    (void)argc;
    (void)argv;

    dev = alcOpenDevice(0);
    ctx = alcCreateContext(dev, 0);

    alcDestroyContext(ctx);
    alcCloseDevice(dev);

    return 0;
}
