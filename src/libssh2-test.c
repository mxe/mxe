/* This file is part of mingw-cross-env.       */
/* See doc/index.html for further information. */

#include <stdio.h>
#include <libssh2.h>

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;
    
    printf("libssh2 version: %s", libssh2_version(0) );
    return 0;
}
