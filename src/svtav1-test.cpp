/*
    This file is part of MXE. See LICENSE.md for licensing information.

    Initial test file scaffold generated using the "gsrc" tool:
    https://github.com/hkunz/git-fetcher

    Compilation (pkg-config):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/svtav1-test.cpp \
        $(./usr/bin/x86_64-w64-mingw32.static-pkg-config --cflags --libs SvtAv1Enc) \
        -o usr/x86_64-w64-mingw32.static/bin/test-svtav1.exe

    Compilation (manual):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/svtav1-test.cpp \
        -I usr/x86_64-w64-mingw32.static/include \
        -L usr/x86_64-w64-mingw32.static/lib \
        -lSvtAv1Enc \
        -o usr/x86_64-w64-mingw32.static/bin/test-svtav1.exe
*/

#include "svt-av1/EbSvtAv1.h"
#include "svt-av1/EbSvtAv1Enc.h"

int main() {
    EbComponentType* encoder = nullptr;
    EbSvtAv1EncConfiguration config;

    // Initialize handle (loads defaults into config)
    if (svt_av1_enc_init_handle(&encoder, &config) != EB_ErrorNone) {
        return 1;
    }

    // Set minimal valid source dimensions
    config.source_width  = 16; // must be >= 4
    config.source_height = 16; // must be >= 4

    // Optionally, choose a simple encoding mode
    config.enc_mode = ENC_M0; // default low-latency preset

    // Apply configuration
    if (svt_av1_enc_set_parameter(encoder, &config) != EB_ErrorNone) {
        return 1;
    }

    // Deinitialize handle
    svt_av1_enc_deinit_handle(encoder);

    return 0;
}
