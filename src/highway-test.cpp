/*
    This file is part of MXE. See LICENSE.md for licensing information.

    Initial test file scaffold generated using the "gsrc" tool:
    https://github.com/hkunz/git-fetcher

    Compilation (pkg-config):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/highway-test.cpp \
        $(./usr/bin/x86_64-w64-mingw32.static-pkg-config --cflags --libs libhwy) \
        -o usr/x86_64-w64-mingw32.static/bin/test-highway.exe

    Compilation (manual):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/highway-test.cpp \
        -I usr/x86_64-w64-mingw32.static/include/ \
        -L usr/x86_64-w64-mingw32.static/lib/ \
        -lhwy \
        -o usr/x86_64-w64-mingw32.static/bin/test-highway.exe
*/

#include <hwy/highway.h>
#include <iostream>

HWY_BEFORE_NAMESPACE();
namespace hwy {
namespace HWY_NAMESPACE {

void TestSIMD() {
    HWY_CAPPED(float, 4) d;           // define a small 4-lane SIMD vector

    // Initialize two vectors
    auto v1 = Set(d, 1.0f);            // all lanes = 1.0
    auto v2 = Set(d, 2.0f);            // all lanes = 2.0

    alignas(16) float lanes[4] = {};  // aligned array for storing

    // Store and print v1
    Store(v1, d, lanes);
    std::cout << "v1 lanes: ";
    for (int i = 0; i < 4; ++i) std::cout << lanes[i] << " ";
    std::cout << std::endl;

    // Store and print v2
    Store(v2, d, lanes);
    std::cout << "v2 lanes: ";
    for (int i = 0; i < 4; ++i) std::cout << lanes[i] << " ";
    std::cout << std::endl;

    // Arithmetic: add vectors
    auto sum = Add(v1, v2);
    Store(sum, d, lanes);
    std::cout << "Sum lanes: ";
    for (int i = 0; i < 4; ++i) std::cout << lanes[i] << " ";
    std::cout << std::endl;

    // Min / Max
    auto minv = Min(v1, v2);
    auto maxv = Max(v1, v2);
    Store(minv, d, lanes);
    std::cout << "Min lanes: ";
    for (int i = 0; i < 4; ++i) std::cout << lanes[i] << " ";
    std::cout << std::endl;
    Store(maxv, d, lanes);
    std::cout << "Max lanes: ";
    for (int i = 0; i < 4; ++i) std::cout << lanes[i] << " ";
    std::cout << std::endl;
}

}  // namespace HWY_NAMESPACE
}  // namespace hwy
HWY_AFTER_NAMESPACE();

int main() {
    hwy::HWY_NAMESPACE::TestSIMD();
    return 0;
}
