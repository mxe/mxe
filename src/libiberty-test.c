/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <libiberty.h>

int main(int argc, char *argv[])
{
    char *s;

    (void)argc;
    (void)argv;

    if (asprintf(&s, "Test%i", 123) >= 0) {
        printf("asprintf output: %s\n", s);
        free(s);
        return 0;
    } else {
        printf("asprintf() failed!\n");
        return 1;
    }
}
