/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <vid.stab/libvidstab.h>

int main(int argc, char *argv[])
{
    VSFrameInfo fi;
    VSMotionDetect md;
    VSMotionDetectConfig conf;

    (void)argc;
    (void)argv;

    conf.algo              = 1;
    conf.modName           = "vidstabtest";
    conf.shakiness         = 5;
    conf.accuracy          = 15;
    conf.stepSize          = 6;
    conf.contrastThreshold = 0.25;
    conf.show              = 0;
    conf.virtualTripod     = 0;

    vsFrameInfoInit(&fi, 320, 240, PF_YUV420P);

    if (vsMotionDetectInit(&md, &conf, &fi) != VS_OK)
        return 1;
    
    vsMotionDetectionCleanup(&md);

    return 0;
}
