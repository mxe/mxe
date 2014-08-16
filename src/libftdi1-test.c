/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <stdio.h>
#include <ftdi.h>

int main(int argc, char *argv[])
{
    int num_devs;
    struct ftdi_context *ctx;
    struct ftdi_device_list *devs = NULL;

    (void)argc;
    (void)argv;

    ctx = ftdi_new();
    if (!ctx) {
        printf("Initialization error.\n");
        return 1;
    }

    num_devs = ftdi_usb_find_all(ctx, &devs, 0, 0);
    if (num_devs < 0) {
        printf("Device list error: %s.\n", ftdi_get_error_string(ctx));
        ftdi_free(ctx);
        return 2;
    }

    printf("Found %d FTDI devices.\n", (int)num_devs);

    ftdi_list_free(&devs);

    ftdi_free(ctx);

    return 0;
}
