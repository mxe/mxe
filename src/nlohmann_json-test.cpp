/*
    Minimal test program for nlohmann_json, verifying basic functionality
    and compatibility with MXE static builds on Windows.

    To compile with MXE (example):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/nlohmann_json-test.cpp \
        -I usr/x86_64-w64-mingw32.static/include \
        -L usr/x86_64-w64-mingw32.static/lib \
        -o usr/x86_64-w64-mingw32.static/bin/test-nlohmann_json.exe
*/

#include <cstdio>
#include <cstdint>
#include <nlohmann/json.hpp>

int main() {
    // Create a simple JSON object
    nlohmann::json j;
    j["name"] = "MXE Test";
    j["version"] = 1.0;
    j["success"] = true;

    // Serialize to string
    std::string s = j.dump();

    // Print JSON string
    printf("JSON output: %s\n", s.c_str());

    // Deserialize back
    auto j2 = nlohmann::json::parse(s);
    if (j2["success"].get<bool>()) {
        printf("JSON parsing succeeded!\n");
    } else {
        printf("JSON parsing failed!\n");
    }

    return 0;
}
