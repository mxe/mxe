/* This file is part of mingw-cross-env.       */
/* See doc/index.html for further information. */

#include <Magick++.h>

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    Magick::InitializeMagick(0);

    Magick::Image image;
    image.quality(90);

    return 0;
}
