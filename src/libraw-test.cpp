/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <iostream>
#include <libraw.h>

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    LibRaw libRaw;
    std::cout << "This is libraw version " << libRaw.version() << std::endl;
    std::cout << libRaw.cameraCount() << " cameras supported." << std::endl;

    return 0;
}
