/*
    This file is part of MXE. See LICENSE.md for licensing information.

    Initial test file scaffold generated using the "gsrc" tool:
    https://github.com/hkunz/git-fetcher

    Compilation (pkg-config):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/de265-test.cpp \
        -DLIBDE265_STATIC_BUILD \
        $(./usr/bin/x86_64-w64-mingw32.static-pkg-config --cflags --libs libde265) \
        -o usr/x86_64-w64-mingw32.static/bin/test-de265.exe

    Compilation (manual):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/de265-test.cpp \
        -DLIBDE265_STATIC_BUILD \
        -I usr/x86_64-w64-mingw32.static/include \
        -L usr/x86_64-w64-mingw32.static/lib \
        -lde265 \
        -lstdc++ -lm -lwinpthread \
        -o usr/x86_64-w64-mingw32.static/bin/test-de265.exe

    The following program decodes testdata/girlshy.h265 which is a raw H.265 stream:
*/

#include <iostream>
#include <fstream>
#include <vector>

#include <libde265/de265.h>

int main()
{
    const char* filename = "girlshy.h265";

    std::ifstream file(filename, std::ios::binary);
    if (!file) {
        std::cerr << "FAIL: cannot open test file\n";
        return 1;
    }

    std::vector<uint8_t> buffer(
        (std::istreambuf_iterator<char>(file)),
        std::istreambuf_iterator<char>()
    );

    de265_decoder_context* ctx = de265_new_decoder();
    if (!ctx) {
        std::cerr << "FAIL: could not create decoder\n";
        return 1;
    }

    de265_push_data(ctx, buffer.data(), buffer.size(), 0, nullptr);

    int frame_count = 0;

    while (true) {

        de265_error err = de265_decode(ctx, nullptr);

        if (err != DE265_OK && err != DE265_ERROR_WAITING_FOR_INPUT_DATA)
            break;

        const de265_image* img = de265_get_next_picture(ctx);

        if (img) {
            frame_count++;
            de265_release_next_picture(ctx);
        }

        if (err == DE265_ERROR_WAITING_FOR_INPUT_DATA)
            break;
    }

    de265_free_decoder(ctx);

    if (frame_count > 0) {
        std::cout << "SUCCESS: decoded " << frame_count << " frames\n";
        return 0;
    } else {
        std::cerr << "FAIL: no frames decoded\n";
        return 1;
    }
}
