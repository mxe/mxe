/* This file is part of mingw-cross-env.       */
/* See doc/index.html for further information. */

/* modified from /examples/arc.c */

#include "gd.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    gdImagePtr im;
    FILE *fp;
    int cor_rad;

    (void)argc;
    (void)argv;

    cor_rad = 400;
    im = gdImageCreateTrueColor(400, 400);
    gdImageFilledRectangle(im, 0, 0, 399, 399, 0x00FFFFFF);
    gdImageFilledArc(im, cor_rad, 399 - cor_rad, cor_rad * 2, cor_rad * 2, 90, 180, 0x0, gdPie);

    fp = fopen("test-gd.png", "wb");
    if (!fp) {
        fprintf(stderr, "Can't save png image.\n");
        gdImageDestroy(im);
        return 1;
    }
    gdImagePng(im, fp);
    fclose(fp);

    fprintf(stdout, "test-gd.png created\n");
    gdImageDestroy(im);
    return 0;
}
