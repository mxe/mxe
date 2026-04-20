/*
    This file is part of MXE. See LICENSE.md for licensing information.

    Initial test file scaffold generated using the "gsrc" tool:
    https://github.com/hkunz/git-fetcher

    Compilation (pkg-config):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/heif-test.cpp \
        $(./usr/bin/x86_64-w64-mingw32.static-pkg-config --cflags --libs libheif) \
        -o usr/x86_64-w64-mingw32.static/bin/test-heif.exe

    Compilation (manual):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/heif-test.cpp \
        -DLIBHEIF_STATIC_BUILD \
        -DHEIF_WITH_OMAF=1 \
        -DLIBDE265_STATIC_BUILD \
        -I usr/x86_64-w64-mingw32.static/include \
        -L usr/x86_64-w64-mingw32.static/lib \
        -static -lheif \
        -lx264 -lx265 -lx265_main10 -lx265_main12 \
        -lde265 \
        -laom -lwebp -lsharpyuv -lopenjp2 -lopenh264 -lz \
        -lpthread -ldav1d \
        -lole32 -luuid -lws2_32 -lstdc++ \
        -o usr/x86_64-w64-mingw32.static/bin/test-heif.exe
*/

#include <libheif/heif.h>
#include <cstdio>

int main() {
    const char* filename = "example.heic"; // example file from heif's repository: https://github.com/hkunz/libheif/blob/master/examples/example.heic

    heif_context* ctx = heif_context_alloc();
    if (!ctx) {
        printf("Failed to allocate HEIF context\n");
        return 1;
    }

    heif_error err = heif_context_read_from_file(ctx, filename, nullptr);
    if (err.code != heif_error_Ok) {
        printf("Error reading HEIF file: %s\n", err.message);
        heif_context_free(ctx);
        return 1;
    }

    heif_image_handle* handle = nullptr;
    err = heif_context_get_primary_image_handle(ctx, &handle);
    if (err.code != heif_error_Ok) {
        printf("Error getting primary image handle: %s\n", err.message);
        heif_context_free(ctx);
        return 1;
    }

    int width = heif_image_handle_get_width(handle);
    int height = heif_image_handle_get_height(handle);
    printf("Image loaded successfully: %dx%d\n", width, height);

    heif_image* img = nullptr;
    err = heif_decode_image(handle, &img, heif_colorspace_undefined, heif_chroma_undefined, nullptr);

    if (err.code != heif_error_Ok) {
        printf("Failed to decode image: %s\n", err.message);
        heif_image_handle_release(handle);
        heif_context_free(ctx);
        return 1;
    }

    heif_colorspace cs = heif_image_get_colorspace(img);
    heif_chroma chroma = heif_image_get_chroma_format(img);
    printf("Colorspace: %d, Chroma: %d\n", cs, chroma);

    heif_image_release(img);
    heif_image_handle_release(handle);
    heif_context_free(ctx);

    return 0;
}
