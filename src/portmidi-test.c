/*
 * This file is part of MXE.
 * See index.html for further information.
 *
 * modified from pm_test/test.c
 */

#include "portmidi.h"
#include "stdio.h"

int main(int argc, char *argv[])
{
    int default_in;
    int default_out;
    int i = 0;
    (void)argc;
    (void)argv;

    /* list device information */
    default_in = Pm_GetDefaultInputDeviceID();
    default_out = Pm_GetDefaultOutputDeviceID();
    printf("number of devices: %s", Pm_CountDevices());
    for (i = 0; i < Pm_CountDevices(); i++) {
        char *deflt;
        const PmDeviceInfo *info = Pm_GetDeviceInfo(i);

        printf("%d: %s, %s", i, info->interf, info->name);
        if (info->input) {
            deflt = (i == default_in ? "default " : "");
            printf(" (%sinput)", deflt);
        }
        if (info->output) {
            deflt = (i == default_out ? "default " : "");
            printf(" (%soutput)", deflt);
        }
    }

    return 0;
}
