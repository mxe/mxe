/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <stdio.h>
#include <string.h>
#include <libslirp.h>

int main(int argc, char *argv[])
{
    Slirp *slirp;
    SlirpConfig config;

    printf("Slirp version %s\n", slirp_version_string());

    memset(&config, 0, sizeof(config));
    config.version = 1;

    slirp = slirp_new(&config, NULL, NULL);
    slirp_cleanup(slirp);

    return 0;
}
