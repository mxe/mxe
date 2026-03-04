#include <iostream>
#include <vector>
#include <string>
#include <pystring/pystring.h>

/*
    Minimal test for pystring header import.

    To compile with MXE (example):
    $ usr/bin/x86_64-w64-mingw32.static-g++ \
        src/pystring-test.cpp \
        -L usr/x86_64-w64-mingw32.static/lib \
        -I usr/x86_64-w64-mingw32.static/include/ \
        -lpystring \
        -o test-pystring.exe
*/

int main() {
    std::string s = "one,two,three";
    std::vector<std::string> parts;

    pystring::split(s, parts, ",");

    for (auto &p : parts)
        std::cout << p << "\n";

    std::cout << "PyString library link test succeeded.\n";
    return 0;
}
