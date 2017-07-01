/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <stdio.h>
#include <GL/glew.h>

#ifdef GLEW_MX
/* We are using the multi-context variant of libGLEW */
GLEWContext glew_context;
GLEWContext* glewGetContext()
{
    return &glew_context;
}
#endif

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
