/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <GL/glut.h>

#include <stdio.h>

int main(int argc, char *argv[])
{
    glutInit(&argc, argv);
    glutInitWindowSize(640,480);
    glutInitWindowPosition(10,10);
    glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE | GLUT_DEPTH);

    glutCreateWindow("FreeGLUT Shapes");

    glutMainLoop();

    return(0);
}
