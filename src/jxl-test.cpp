/*
    This file is part of MXE. See LICENSE.md for licensing information.

    Initial test file scaffold generated using the "gsrc" tool:
    https://github.com/hkunz/git-fetcher

    Compilation (pkg-config):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/jxl-test.cpp \
        $(./usr/bin/x86_64-w64-mingw32.static-pkg-config --cflags --libs libjxl) \
        -o usr/x86_64-w64-mingw32.static/bin/test-jxl.exe

    Compilation (manual):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/jxl-test.cpp \
        -I usr/x86_64-w64-mingw32.static/include \
        -L usr/x86_64-w64-mingw32.static/lib \
        -DJXL_STATIC_DEFINE \
        -o usr/x86_64-w64-mingw32.static/bin/test-jxl.exe \
        -ljxl -ljxl_threads -ljxl_cms \
        -lbrotlienc -lbrotlidec -lbrotlicommon \
        -lhwy -llcms2 \
        -lwinpthread -lm -lstdc++ \
        -o usr/x86_64-w64-mingw32.static/bin/test-jxl.exe
*/

#include <jxl/encode.h>
#include <jxl/decode.h>
#include <jxl/thread_parallel_runner.h>
#include <jxl/types.h>
#include <stdio.h>
#include <string.h>

int main() {
    // Signature test (matches one of your missing refs)
    const uint8_t fake_data[12] = {0};
    JxlSignature sig = JxlSignatureCheck(fake_data, sizeof(fake_data));
    printf("JxlSignatureCheck OK, result = %d\n", (int)sig);

    // Create encoder
    JxlEncoder* enc = JxlEncoderCreate(NULL);
    if (!enc) {
        printf("Failed to create JxlEncoder\n");
        return 1;
    }

    // Create decoder
    JxlDecoder* dec = JxlDecoderCreate(NULL);
    if (!dec) {
        printf("Failed to create JxlDecoder\n");
        JxlEncoderDestroy(enc);
        return 1;
    }

    printf("Encoder + Decoder created successfully\n");

    // Thread runner test
    void* runner = JxlThreadParallelRunnerCreate(NULL, 2);
    if (!runner) {
        printf("Failed to create thread runner\n");
        JxlEncoderDestroy(enc);
        JxlDecoderDestroy(dec);
        return 1;
    }

    if (JxlEncoderSetParallelRunner(enc,
            JxlThreadParallelRunner,
            runner) != JXL_ENC_SUCCESS) {
        printf("JxlEncoderSetParallelRunner failed\n");
    } else {
        printf("JxlEncoderSetParallelRunner OK\n");
    }

    if (JxlDecoderSetParallelRunner(dec,
            JxlThreadParallelRunner,
            runner) != JXL_DEC_SUCCESS) {
        printf("JxlDecoderSetParallelRunner failed\n");
    } else {
        printf("JxlDecoderSetParallelRunner OK\n");
    }

    // Basic encoder info test
    JxlBasicInfo info;
    JxlEncoderInitBasicInfo(&info);
    info.xsize = 64;
    info.ysize = 64;
    info.bits_per_sample = 8;
    info.num_color_channels = 3;
    info.num_extra_channels = 0;
    info.alpha_bits = 0;

    if (JxlEncoderSetBasicInfo(enc, &info) != JXL_ENC_SUCCESS) {
        printf("JxlEncoderSetBasicInfo failed\n");
    } else {
        printf("JxlEncoderSetBasicInfo OK\n");
    }

    // Color encoding test
    JxlColorEncoding color;
    JxlColorEncodingSetToSRGB(&color, 0);

    if (JxlEncoderSetColorEncoding(enc, &color) != JXL_ENC_SUCCESS) {
        printf("JxlEncoderSetColorEncoding failed\n");
    } else {
        printf("JxlEncoderSetColorEncoding OK\n");
    }

    // Cleanup
    JxlThreadParallelRunnerDestroy(runner);
    JxlEncoderDestroy(enc);
    JxlDecoderDestroy(dec);

    printf("All selected libjxl symbols worked.\n");
    return 0;
}