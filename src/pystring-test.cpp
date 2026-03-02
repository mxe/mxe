#include <iostream>
#include <vector>
#include <string>
#include "pystring/pystring.h"

/*
    Minimal test for pystring header import.

    To compile with MXE (example):
    $ usr/bin/x86_64-w64-mingw32.static-g++ \
        src/pystring-test.cpp \
        -I usr/x86_64-w64-mingw32.static/include/ \
        -o test-pystring.exe
*/

int main() {
    std::string s = "one,two,three";
    std::vector<std::string> parts;
    //pystring::split(s, parts, ","); //cannot do this because we are only testing a header import
    //for (auto &p : parts) std::cout << p << "\n";
    return 0;
}
