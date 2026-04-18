/*
    This file is part of MXE. See LICENSE.md for licensing information.

    Initial test file scaffold generated using the "gsrc" tool:
    https://github.com/hkunz/git-fetcher

    Compilation (pkg-config):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/jemalloc-test.cpp \
        $(./usr/bin/x86_64-w64-mingw32.static-pkg-config --cflags --libs jemalloc) \
        -o usr/x86_64-w64-mingw32.static/bin/test-jemalloc.exe

    Compilation (manual):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/jemalloc-test.cpp \
        -I usr/x86_64-w64-mingw32.static/include \
        -L usr/x86_64-w64-mingw32.static/lib \
        -ljemalloc \
        -o usr/x86_64-w64-mingw32.static/bin/test-jemalloc.exe
*/

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <jemalloc/jemalloc.h>

int main() {
    printf("jemalloc test start\n");

    for (int i = 0; i < 5000; i++) {
        void* p = je_mallocx(32 + (i % 128), 0);
        if (!p) {
            printf("alloc failed\n");
            return 1;
        }
        memset(p, 0xA5, 32);
        je_dallocx(p, 0);
    }

    printf("basic stress OK\n");

    je_malloc_stats_print(nullptr, nullptr, nullptr);

    printf("done\n");
    return 0;
}
