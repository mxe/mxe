/*
    This file is part of MXE. See LICENSE.md for licensing information.

    Initial test file scaffold generated using the "gsrc" tool:
    https://github.com/hkunz/git-fetcher

    Compilation (manual):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/robin-map-test.cpp \
        -o usr/x86_64-w64-mingw32.static/bin/test-robin-map.exe
*/

#include <iostream>
#include <string>
#include <tsl/robin_map.h>

int main() {

    tsl::robin_map<std::string, int> map;

    map["apple"] = 1;
    map["banana"] = 2;
    map["orange"] = 3;

    // Access values
    std::cout << "apple = " << map["apple"] << std::endl;
    std::cout << "banana = " << map["banana"] << std::endl;
    std::cout << "orange = " << map["orange"] << std::endl;

    // Test lookup
    auto it = map.find("banana");
    if (it != map.end()) {
        std::cout << "Found banana: " << it->second << std::endl;
    } else {
        std::cout << "banana not found" << std::endl;
    }

    // Check non-existing key
    if (map.find("grape") == map.end()) {
        std::cout << "grape not found (expected)" << std::endl;
    }

    std::cout << "robin-map test OK" << std::endl;
    return 0;
}
