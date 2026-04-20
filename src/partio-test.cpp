/*
    This file is part of MXE. See LICENSE.md for licensing information.

    Initial test file scaffold generated using the "gsrc" tool:
    https://github.com/hkunz/git-fetcher

    Compilation (pkg-config):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/partio-test.cpp \
        $(./usr/bin/x86_64-w64-mingw32.static-pkg-config --cflags --libs partio) \
        -o usr/x86_64-w64-mingw32.static/bin/test-partio.exe

    Compilation (manual):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/partio-test.cpp \
        -I usr/x86_64-w64-mingw32.static/include \
        -L usr/x86_64-w64-mingw32.static/lib \
        -lpartio -lz -lpthread \
        -o usr/x86_64-w64-mingw32.static/bin/test-partio.exe
*/

#include <Partio.h>
#include <cstdio>

int main() {
    Partio::ParticlesDataMutable* particles = Partio::create();
    if (!particles) {
        printf("Failed to create Partio particles\n");
        return 1;
    }

    // Optionally add a particle
    int idx = particles->addParticle();
    printf("Added particle index: %d\n", idx);

    // Clean up
    particles->release();
    printf("Partio test completed successfully.\n");
    return 0;
}
