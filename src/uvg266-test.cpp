/*
    This file is part of MXE. See LICENSE.md for licensing information.

    Initial test file scaffold generated using the "gsrc" tool:
    https://github.com/hkunz/git-fetcher

    Compilation (pkg-config):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/uvg266-test.cpp \
        $(./usr/bin/x86_64-w64-mingw32.static-pkg-config --cflags --libs uvg266) \
        -o usr/x86_64-w64-mingw32.static/bin/test-uvg266.exe

    Compilation (manual):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/uvg266-test.cpp \
        -I usr/x86_64-w64-mingw32.static/include \
        -L usr/x86_64-w64-mingw32.static/lib \
        -luvg266 \
        -o usr/x86_64-w64-mingw32.static/bin/test-uvg266.exe
*/

#include <cstdlib>
#include <iostream>

int main() {
    int ret = std::system("uvg266.exe --version");
    if (ret == 0) {
        std::cout << "uvg266 CLI encoder ran successfully!" << std::endl;
    } else {
        std::cerr << "uvg266 CLI encoder failed!" << std::endl;
    }
    return ret;
}
