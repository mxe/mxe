/*
    Minimal test program for OpenEXR library, verifying basic functionality
    and compatibility with MXE static builds on Windows.

    To compile with MXE (example):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/openexr-test.cpp \
        $(./usr/bin/x86_64-w64-mingw32.static-pkg-config --cflags --libs OpenEXR) \
        -o usr/x86_64-w64-mingw32.static/bin/test-openexr.exe

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/openexr-test.cpp \
        -I usr/x86_64-w64-mingw32.static/include/ \
        -I usr/x86_64-w64-mingw32.static/include/OpenEXR \
        -I usr/x86_64-w64-mingw32.static/include/Imath \
        -L usr/x86_64-w64-mingw32.static/lib/ \
        -lOpenEXR-3_4 \
        -lOpenEXRUtil-3_4 \
        -lOpenEXRCore-3_4 \
        -lIex-3_4 \
        -lIlmThread-3_4 \
        -lImath-3_2 \
        -lopenjph \
        -ldeflate \
        -lpthread \
        -o usr/x86_64-w64-mingw32.static/bin/test-openexr.exe
*/

#include <OpenEXR/ImfRgbaFile.h>
#include <OpenEXR/ImfRgba.h>
#include <iostream>
#include <vector>

int main() {
    std::cout << "OpenEXR test program\n";

    // Create a 4x4 RGBA image in memory
    const int width = 4;
    const int height = 4;
    std::vector<Imf::Rgba> pixels(width * height);

    for (int y = 0; y < height; ++y)
        for (int x = 0; x < width; ++x)
            pixels[y * width + x] = Imf::Rgba(
                float(x) / width,
                float(y) / height,
                0.5f,
                1.0f
            );

    const char* filename = "test.exr";

    // Write EXR
    try {
        Imf::RgbaOutputFile file(filename, width, height, Imf::WRITE_RGBA);
        file.setFrameBuffer(pixels.data(), 1, width);
        file.writePixels(height);
        std::cout << "Wrote " << filename << "\n";
    } catch (const std::exception& e) {
        std::cerr << "Error writing EXR: " << e.what() << "\n";
        return 1;
    }

    // Read EXR
    try {
        Imf::RgbaInputFile file(filename);
        Imath::Box2i dw = file.dataWindow();
        int w = dw.max.x - dw.min.x + 1;
        int h = dw.max.y - dw.min.y + 1;

        std::vector<Imf::Rgba> readPixels(w * h);
        file.setFrameBuffer(readPixels.data(), 1, w);
        file.readPixels(0, h-1);

        std::cout << "Read " << filename << " successfully! First pixel RGBA: "
                  << readPixels[0].r << " "
                  << readPixels[0].g << " "
                  << readPixels[0].b << " "
                  << readPixels[0].a << "\n";

    } catch (const std::exception& e) {
        std::cerr << "Error reading EXR: " << e.what() << "\n";
        return 1;
    }

    return 0;
}
