/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <stdlib.h>
#include <GL/glfw.h>

int main(void)
{
    /* Initialise GLFW */
    if( !glfwInit() )
    {
        return EXIT_FAILURE;
    }

    /* Open a window and create its OpenGL context */
    if( !glfwOpenWindow( 640, 480, 0,0,0,0, 0,0, GLFW_WINDOW ) )
    {
        glfwTerminate();
        return EXIT_FAILURE;
    }

    /* Close OpenGL window and terminate GLFW*/
    glfwTerminate();

    return EXIT_SUCCESS;
}
