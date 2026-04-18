/*
    This file is part of MXE. See LICENSE.md for licensing information.

    Initial test file scaffold generated using the "gsrc" tool:
    https://github.com/hkunz/git-fetcher

    Compilation (pkg-config):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/aom-test.cpp \
        $(./usr/bin/x86_64-w64-mingw32.static-pkg-config --cflags --libs aom) \
        -o usr/x86_64-w64-mingw32.static/bin/test-aom.exe

    Compilation (manual):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/aom-test.cpp \
        -I usr/x86_64-w64-mingw32.static/include \
        -L usr/x86_64-w64-mingw32.static/lib \
        -laom \
        -o usr/x86_64-w64-mingw32.static/bin/test-aom.exe
*/

#include <cstdio>
#include <cstdint>
#include <aom/aom_encoder.h>
#include <aom/aomcx.h>

int main() {
    // Print libaom version
    const char* version = aom_codec_version_str();
    printf("libaom version: %s\n", version);

    // Prepare encoder interface
    aom_codec_iface_t* iface = aom_codec_av1_cx(); // AV1 encoder
    aom_codec_ctx_t codec;
    aom_codec_enc_cfg_t cfg;

    // Get default configuration
    if (aom_codec_enc_config_default(iface, &cfg, 0)) {
        printf("Failed to get default encoder config\n");
        return 1;
    }

    // Change a simple parameter
    cfg.g_w = 128;  // width
    cfg.g_h = 128;  // height
    cfg.g_timebase.num = 1;
    cfg.g_timebase.den = 30;

    // Initialize codec
    if (aom_codec_enc_init(&codec, iface, &cfg, 0)) {
        printf("Failed to initialize encoder\n");
        return 1;
    }

    printf("Encoder initialized successfully!\n");

    // Clean up
    aom_codec_destroy(&codec);

    return 0;
}
