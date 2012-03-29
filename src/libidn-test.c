/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <stdlib.h>
#include <idna.h>

int main(int argc, char *argv[])
{
    char *hostname_ascii;

    (void)argc;
    (void)argv;

    if (idna_to_ascii_lz("www.google.com", &hostname_ascii, 0) == IDNA_SUCCESS)
    {
        free(hostname_ascii);
    }

    return 0;
}
