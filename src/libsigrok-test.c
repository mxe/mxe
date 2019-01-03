/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <stdio.h>
#include <libsigrok/libsigrok.h>

int main(int argc, char **argv)
{
    int ret;
    struct sr_context *sr_ctx;
    (void)argc;
    (void)argv;

    if ((ret = sr_init(&sr_ctx)) != SR_OK) {
          printf("Error initializing libsigrok (%s): %s.\n",
                 sr_strerror_name(ret), sr_strerror(ret));
          return 1;
    }
    if ((ret = sr_exit(sr_ctx)) != SR_OK) {
          printf("Error shutting down libsigrok (%s): %s.\n",
                 sr_strerror_name(ret), sr_strerror(ret));
          return 1;
    }
    return 0;
}
