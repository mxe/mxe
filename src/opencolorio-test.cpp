/*
    This file is part of MXE. See LICENSE.md for licensing information.

    Initial test file scaffold generated using the "gsrc" tool:
    https://github.com/hkunz/git-fetcher

    Compilation (pkg-config):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/opencolorio-test.cpp \
        $(./usr/bin/x86_64-w64-mingw32.static-pkg-config --cflags --libs OpenColorIO) \
        -o usr/x86_64-w64-mingw32.static/bin/test-opencolorio.exe

    Compilation (manual):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/opencolorio-test.cpp \
        -DOpenColorIO_SKIP_IMPORTS \
        -I usr/x86_64-w64-mingw32.static/include \
        -L usr/x86_64-w64-mingw32.static/lib \
        -lOpenColorIO \
        -lImath-3_2 \
        -lyaml-cpp \
        -lexpat \
        -lminizip \
        -lz \
        -lbz2 \
        -llzma \
        -lzstd \
        -lpystring \
        -lbcrypt \
        -lgdi32 \
        -o usr/x86_64-w64-mingw32.static/bin/test-opencolorio.exe
*/

#include <OpenColorIO/OpenColorIO.h>
#include <iostream>

namespace OCIO = OCIO_NAMESPACE;

int main()
{
    try
    {
        // Get current config (should always exist)
        OCIO::ConstConfigRcPtr config = OCIO::GetCurrentConfig();

        std::cout << "OpenColorIO version: "
                  << OCIO::GetVersion() << std::endl;

        std::cout << "Default display: "
                  << config->getDefaultDisplay() << std::endl;

        std::cout << "Default view: "
                  << config->getDefaultView(config->getDefaultDisplay())
                  << std::endl;

        std::cout << "OCIO test succeeded." << std::endl;
        return 0;
    }
    catch (const std::exception & e)
    {
        std::cerr << "OCIO error: " << e.what() << std::endl;
        return 1;
    }
}
