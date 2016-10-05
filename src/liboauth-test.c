/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <stdio.h>
#include <oauth.h>

int main (int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    printf("Nonce: %s", oauth_gen_nonce());
    return (0);
}
