/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <gphoto2/gphoto2-camera.h>


int main(int argc, char *argv[])
{
    Camera *camera;

    gp_camera_new(&camera);
    gp_camera_unref(camera);

    return 0;
}
