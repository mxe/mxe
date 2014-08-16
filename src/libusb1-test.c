/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <stdio.h>
#include <libusb.h>

int main(int argc, char *argv[])
{
    int ret;
    ssize_t num_devs;
    libusb_context *ctx;
    libusb_device **devs;

    (void)argc;
    (void)argv;

    ret = libusb_init(&ctx);
    if (ret != LIBUSB_SUCCESS) {
        printf("Initialization error: %s.\n", libusb_error_name(ret));
        return 1;
    }

    num_devs = libusb_get_device_list(ctx, &devs);
    if (num_devs < 0 || !devs) {
        printf("Device list error: %s.\n", libusb_error_name(num_devs));
        return 2;
    }

    printf("Found %d USB devices.\n", (int)num_devs);

    libusb_free_device_list(devs, 1);

    libusb_exit(ctx);

    return 0;
}

