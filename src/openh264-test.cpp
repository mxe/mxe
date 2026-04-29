/*
    This file is part of MXE. See LICENSE.md for licensing information.

    Initial test file scaffold generated using the "gsrc" tool:
    https://github.com/hkunz/git-fetcher

    Compilation (pkg-config):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/openh264-test.cpp \
        $(./usr/bin/x86_64-w64-mingw32.static-pkg-config --cflags --libs openh264) \
        -o usr/x86_64-w64-mingw32.static/bin/test-openh264.exe

    Compilation (manual):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/openh264-test.cpp \
        -I usr/x86_64-w64-mingw32.static/include \
        -L usr/x86_64-w64-mingw32.static/lib \
        -lopenh264 \
        -o usr/x86_64-w64-mingw32.static/bin/test-openh264.exe
*/

#include <iostream>
#include "wels/codec_api.h"

int main() {
    ISVCEncoder* encoder = nullptr;

    // Create encoder
    if (WelsCreateSVCEncoder(&encoder) != 0 || !encoder) {
        std::cerr << "Failed to create encoder." << std::endl;
        return 1;
    }

    // Get default extended encoding parameters
    SEncParamExt paramExt;
    encoder->GetDefaultParams(&paramExt);

    // Modify parameters
    paramExt.iPicWidth = 640;
    paramExt.iPicHeight = 480;
    paramExt.iTargetBitrate = 500000; // 500 kbps

    // Initialize encoder
    if (encoder->Initialize(reinterpret_cast<const SEncParamBase*>(&paramExt)) != 0) {
        std::cerr << "Failed to initialize encoder." << std::endl;
        encoder->Uninitialize();
        WelsDestroySVCEncoder(encoder);
        return 1;
    }

    std::cout << "Encoder initialized successfully!" << std::endl;

    // Uninitialize and destroy
    encoder->Uninitialize();
    WelsDestroySVCEncoder(encoder);

    return 0;
}
