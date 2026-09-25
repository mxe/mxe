/*
    This file is part of MXE. See LICENSE.md for licensing information.

    Initial test file scaffold generated using the "gsrc" tool:
    https://github.com/hkunz/git-fetcher

    Compilation (pkg-config):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/opensubdiv-test.cpp \
        $(./usr/bin/x86_64-w64-mingw32.static-pkg-config --cflags --libs opensubdiv) \
        -o usr/x86_64-w64-mingw32.static/bin/test-opensubdiv.exe

    Compilation (manual):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/opensubdiv-test.cpp \
        -I usr/x86_64-w64-mingw32.static/include \
        -L usr/x86_64-w64-mingw32.static/lib \
        -losdCPU \
        -o usr/x86_64-w64-mingw32.static/bin/test-opensubdiv.exe
*/

#include <opensubdiv/osd/cpuVertexBuffer.h>
#include <iostream>

class TestBuffer : public OpenSubdiv::Osd::CpuVertexBuffer {
public:
    TestBuffer(int elements, int verts) : CpuVertexBuffer(elements, verts) {}
};

int main() {
    TestBuffer buffer(3, 3);

    std::cout << "OpenSubdiv CPU link test succeeded." << std::endl;
    return 0;
}
