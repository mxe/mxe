/*
 * This file is part of MXE.
 * See index.html for further information.
 *
 * This is a slightly modified version of:
 * examples/arc.c
 */

#include "gd.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    gdImagePtr im;
    FILE *fp, *fj, *fg;
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

    fj = fopen("test-gd.jpg", "wb");
    if (!fj) {
        fprintf(stderr, "Can't save jpeg image.\n");
        gdImageDestroy(im);
        return 1;
    }
    gdImageJpeg(im, fj, 50);
    fclose(fj);

    fprintf(stdout, "test-gd.jpg created\n");

    fg = fopen("test-gd.gif", "wb");
    if (!fg) {
        fprintf(stderr, "Can't save gif image.\n");
        gdImageDestroy(im);
        return 1;
    }
    gdImageGif(im, fg);
    fclose(fg);

    fprintf(stdout, "test-gd.gif created\n");
    gdImageDestroy(im);
    return 0;
}
