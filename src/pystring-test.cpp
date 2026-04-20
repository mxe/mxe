/*
    This file is part of MXE. See LICENSE.md for licensing information.

    Initial test file scaffold generated using the "gsrc" tool:
    https://github.com/hkunz/git-fetcher

    Compilation (pkg-config):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/pystring-test.cpp \
        $(./usr/bin/x86_64-w64-mingw32.static-pkg-config --cflags --libs pystring) \
        -o usr/x86_64-w64-mingw32.static/bin/test-pystring.exe

    Compilation (manual):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/pystring-test.cpp \
        -I usr/x86_64-w64-mingw32.static/include \
        -L usr/x86_64-w64-mingw32.static/lib \
        -lpystring \
        -o usr/x86_64-w64-mingw32.static/bin/test-pystring.exe
*/

#include <iostream>
#include <vector>
#include <string>
#include <pystring/pystring.h>

int main() {
    std::string s = "one,two,three";
    std::vector<std::string> parts;

    pystring::split(s, parts, ",");

    for (auto &p : parts)
        std::cout << p << "\n";

    std::cout << "PyString library link test succeeded.\n";
    return 0;
}
