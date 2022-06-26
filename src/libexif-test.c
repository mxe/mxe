/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <libexif/exif-loader.h>

int main(int argc, char *argv[])
{
    ExifLoader *l;

    l = exif_loader_new();
    exif_loader_unref(l);

    return 0;
}
