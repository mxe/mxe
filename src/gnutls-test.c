/* This file is part of mingw-cross-env.       */
/* See doc/index.html for further information. */

#include <gnutls/gnutls.h>

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    gnutls_global_init ();

    gnutls_global_deinit ();

    return 0;
}
