/*
    Minimal test program for vvdec, verifying basic functionality
    and compatibility with MXE static builds on Windows.

    To compile with MXE (example):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/vvdec-test.cpp \
        -I usr/x86_64-w64-mingw32.static/include \
        -L usr/x86_64-w64-mingw32.static/lib \
        -lvvdec \
        -o usr/x86_64-w64-mingw32.static/bin/test-vvdec.exe
*/

#include <vvdec/vvdec.h>
#include <cstdio>
#include <cstring>

int main() {
    // Print version
    printf("VVDEC version: %s\n", vvdec_get_version());

    // Initialize parameters manually
    vvdecParams params;
    std::memset(&params, 0, sizeof(params));
    params.threads = 1;  // example: set 1 thread

    // Open decoder
    vvdecDecoder* decoder = vvdec_decoder_open(&params);
    if (!decoder) {
        printf("Failed to create decoder\n");
        return 1;
    }

    // Close decoder
    vvdec_decoder_close(decoder);

    printf("VVDEC test done\n");
    return 0;
}
