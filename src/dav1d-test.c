/*
    This file is part of MXE. See LICENSE.md for licensing information.

    Initial test file scaffold generated using the "gsrc" tool:
    https://github.com/hkunz/git-fetcher

    Compilation (pkg-config):

    ./usr/bin/x86_64-w64-mingw32.static-gcc \
        src/dav1d-test.c \
        $(./usr/bin/x86_64-w64-mingw32.static-pkg-config --cflags --libs dav1d) \
        -o usr/x86_64-w64-mingw32.static/bin/test-dav1d.exe

    Compilation (manual):

    ./usr/bin/x86_64-w64-mingw32.static-gcc \
        src/dav1d-test.c \
        -I usr/x86_64-w64-mingw32.static/include \
        -L usr/x86_64-w64-mingw32.static/lib \
        -ldav1d \
        -o usr/x86_64-w64-mingw32.static/bin/test-dav1d.exe
*/

#include <stdio.h>
#include <stdint.h>
#include <dav1d/dav1d.h>

int main() {
    Dav1dSettings s;
    Dav1dContext *c = NULL;
    int ret;

    // Initialize settings with defaults
    dav1d_default_settings(&s);

    // Optionally tweak settings
    s.n_threads = 1; // single-thread for test

    // Open decoder
    ret = dav1d_open(&c, &s);
    if (ret < 0) {
        fprintf(stderr, "Failed to open dav1d decoder: %d\n", ret);
        return 1;
    }

    printf("dav1d decoder initialized successfully!\n");

    // Close decoder
    dav1d_close(&c);

    printf("dav1d decoder closed successfully!\n");
    return 0;
}
