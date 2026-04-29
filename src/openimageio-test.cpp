/*
    This file is part of MXE. See LICENSE.md for licensing information.

    Initial test file scaffold generated using the "gsrc" tool:
    https://github.com/hkunz/git-fetcher

    Compilation (pkg-config):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/openimageio-test.cpp \
        $(./usr/bin/x86_64-w64-mingw32.static-pkg-config --cflags --libs OpenImageIO) \
        -o usr/x86_64-w64-mingw32.static/bin/test-openimageio.exe
*/

#include <OpenImageIO/imageio.h>
#include <iostream>
#include <vector>

int main()
{
    const char* filename = "checker_with_alpha.exr";

    std::unique_ptr<OpenImageIO::v3_1::ImageInput> in =
        OpenImageIO::v3_1::ImageInput::open(filename);

    if (!in) {
        std::cerr << "open failed\n";
        return 1;
    }

    const OpenImageIO::v3_1::ImageSpec& spec = in->spec();

    std::cout << spec.width << "x" << spec.height << "\n";

    std::vector<float> pixels(spec.width * spec.height * spec.nchannels);

    if (!in->read_image(0, 0, 0, spec.nchannels,
                        OpenImageIO::v3_1::TypeFloat,
                        pixels.data()))
    {
        std::cerr << "read failed\n";
        return 1;
    }

    std::cout << "OK\n";
    return 0;
}