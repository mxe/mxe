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

#include <opensubdiv/osd/cpuEvaluator.h>
#include <opensubdiv/osd/cpuVertexBuffer.h>
#include <iostream>

int main() {
    std::cout << "OpenSubdiv CPU link test succeeded." << std::endl;
    return 0;
}
