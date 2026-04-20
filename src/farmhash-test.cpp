/*
    This file is part of MXE. See LICENSE.md for licensing information.

    Initial test file scaffold generated using the "gsrc" tool:
    https://github.com/hkunz/git-fetcher

    Compilation (pkg-config):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/farmhash-test.cpp \
        $(./usr/bin/x86_64-w64-mingw32.static-pkg-config --cflags --libs farmhash) \
        -o usr/x86_64-w64-mingw32.static/bin/test-farmhash.exe

    Compilation (manual):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/farmhash-test.cpp \
        -I usr/x86_64-w64-mingw32.static/include \
        -L usr/x86_64-w64-mingw32.static/lib \
        -lfarmhash \
        -o usr/x86_64-w64-mingw32.static/bin/test-farmhash.exe
*/

#include <iostream>
#include "farmhash.h"

int main() {
    const char* testString = "Hello, FarmHash!";

    // Compute 32-bit and 64-bit hashes
    uint32_t hash32 = util::Hash32(testString, strlen(testString));
    uint64_t hash64 = util::Hash64(testString, strlen(testString));

    std::cout << "Test string: " << testString << "\n";
    std::cout << "32-bit hash: " << hash32 << "\n";
    std::cout << "64-bit hash: " << hash64 << "\n";

    // Simple consistency check
    uint64_t hash64_repeat = util::Hash64(testString, strlen(testString));
    if (hash64 == hash64_repeat) {
        std::cout << "64-bit hash is consistent\n";
    } else {
        std::cout << "64-bit hash mismatch\n";
    }

    return 0;
}
