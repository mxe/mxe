/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <stdio.h>
#include <libssh2.h>

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;
    libssh2_init(0);
    printf("libssh2 version: %s", libssh2_version(0) );
    libssh2_exit();
    return 0;
}
