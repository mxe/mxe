/* This file is part of mingw-cross-env.       */
/* See doc/index.html for further information. */

#include <stdio.h>
#include <GL/glew.h>

int main(int argc, char *argv[])
{
    GLenum err;

    (void)argc;
    (void)argv;

    err = glewInit();
    if (GLEW_OK != err)
    {
        fprintf(stderr, "Error: %s\n", glewGetErrorString(err));
    }
    fprintf(stdout, "Status: Using GLEW %s\n", glewGetString(GLEW_VERSION));

    return 0;
}
