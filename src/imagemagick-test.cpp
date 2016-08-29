/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <Magick++.h>

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    Magick::Image image;
    image.quality(90);

    return 0;
}
