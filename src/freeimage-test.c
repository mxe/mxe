/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <stdio.h>
#include <FreeImage.h>

int main(int argc, char* argv[])
{
    (void)argc;
    (void)argv;

    printf("FreeImage: %s\n", FreeImage_GetVersion());
    return 0;
}
