/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <stdio.h>

int main(int argc, char** argv) {
    if (argc >= 2) {
        printf("argv[1] = %s\n", argv[1]);
    }
    return 0;
}
