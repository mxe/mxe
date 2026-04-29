/*
    This file is part of MXE. See LICENSE.md for licensing information.

    Initial test file scaffold generated using the "gsrc" tool:
    https://github.com/hkunz/git-fetcher

    Compilation (pkg-config):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/skcms-test.cpp \
        $(./usr/bin/x86_64-w64-mingw32.static-pkg-config --cflags --libs skcms) \
        -o usr/x86_64-w64-mingw32.static/bin/test-skcms.exe

    Compilation (manual):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/skcms-test.cpp \
        -I usr/x86_64-w64-mingw32.static/include/ \
        -L usr/x86_64-w64-mingw32.static/lib/ \
        -lskcms \
        -o usr/x86_64-w64-mingw32.static/bin/test-skcms.exe
*/

#include <cstdio>
#include <cstdint>
#include <skcms/skcms.h>

int main() {
    printf("Testing skcms library...\n");

    // Get sRGB profile
    const skcms_ICCProfile* profile = skcms_sRGB_profile();
    if (!profile) {
        fprintf(stderr, "Failed to get sRGB profile!\n");
        return 1;
    }

    printf("sRGB profile loaded successfully\n");

    // Done
    printf("skcms test completed successfully!\n");
    return 0;
}