/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <libircclient/libircclient.h>

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    irc_callbacks_t callbacks;
    memset(&callbacks, 0, sizeof(callbacks));

    irc_create_session(&callbacks);
    return 0;
}
