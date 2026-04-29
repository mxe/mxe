/*
    This file is part of MXE. See LICENSE.md for licensing information.

    Initial test file scaffold generated using the "gsrc" tool:
    https://github.com/hkunz/git-fetcher

    Compilation (pkg-config):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/uhdr-test.cpp \
        $(./usr/bin/x86_64-w64-mingw32.static-pkg-config --cflags --libs uhdr) \
        -o usr/x86_64-w64-mingw32.static/bin/test-uhdr.exe

    Compilation (manual):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/uhdr-test.cpp \
        -I usr/x86_64-w64-mingw32.static/include \
        -L usr/x86_64-w64-mingw32.static/lib \
        -luhdr -ljpeg -lpthread \
        -o usr/x86_64-w64-mingw32.static/bin/test-uhdr.exe
*/

#include <ultrahdr_api.h>
#include <cstdio>

int main() {
    uhdr_error_info_t info;

    uhdr_codec_private_t* codec = uhdr_create_decoder();

    if (!codec) {
        std::printf("FAILED: decoder creation returned null\n");
        return 1;
    }

    uhdr_release_decoder(codec);

    std::printf("UltraHDR library link + runtime OK\n");
    return 0;
}