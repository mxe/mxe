/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 *
 * This is a  modified version of:
 * test/CTest.c
 */


#include <FTGL/ftgl.h>

#define ALLOC(ctor, var, arg) \
    var = ctor(arg); \
    if(var == NULL) \
        return 2

int main(int argc, char *argv[])
{
    FTGLfont *f[6];
    (void)argc;
    int i;

    ALLOC(ftglCreateBitmapFont, f[0], argv[1]);
    ALLOC(ftglCreateExtrudeFont, f[1], argv[1]);
    ALLOC(ftglCreateOutlineFont, f[2], argv[1]);
    ALLOC(ftglCreatePixmapFont, f[3], argv[1]);
    ALLOC(ftglCreatePolygonFont, f[4], argv[1]);
    ALLOC(ftglCreateTextureFont, f[5], argv[1]);

    for(i = 0; i < 6; i++)
        ftglRenderFont(f[i], "Hello world", FTGL_RENDER_ALL);

    for(i = 0; i < 6; i++)
        ftglSetFontFaceSize(f[i], 37, 72);

    for(i = 0; i < 6; i++)
        ftglRenderFont(f[i], "Hello world", FTGL_RENDER_ALL);

    for(i = 0; i < 6; i++)
        ftglDestroyFont(f[i]);

    return 0;
}

