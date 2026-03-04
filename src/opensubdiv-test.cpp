/*
    Minimal OpenSubdiv Test
    Build with MXE (Windows):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        -Wall \
        src/opensubdiv-test.cpp \
        -I usr/x86_64-w64-mingw32.static/include \
        -L usr/x86_64-w64-mingw32.static/lib \
        -losdCPU -ltbb12 \
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
