/*
    This file is part of MXE. See LICENSE.md for licensing information.

    Initial test file scaffold generated using the "gsrc" tool:
    https://github.com/hkunz/git-fetcher

    Compilation (manual):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/nlohmann_json-test.cpp \
        -I usr/x86_64-w64-mingw32.static/include \
        -o usr/x86_64-w64-mingw32.static/bin/test-nlohmann_json.exe
*/

#include <nlohmann/json.hpp>

using nlohmann::json;

int main() {
    json j = json::parse(R"({"status": "success"})");
    return (j["status"] != "success");
}
