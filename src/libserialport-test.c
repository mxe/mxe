/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <stdio.h>
#include <libserialport.h>

int main(int argc, char *argv[])
{
    int i;
    struct sp_port **ports;
    (void)argc;
    (void)argv;

    sp_list_ports(&ports);

    for (i = 0; ports[i]; i++)
        printf("Found port: '%s'.\n", sp_get_port_name(ports[i]));

    sp_free_port_list(ports);

    return 0;
}
