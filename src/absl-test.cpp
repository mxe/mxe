/*
    This file is part of MXE. See LICENSE.md for licensing information.

    Initial test file scaffold generated using the "gsrc" tool:
    https://github.com/hkunz/git-fetcher

    Compilation (pkg-config):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/absl-test.cpp \
        $(./usr/bin/x86_64-w64-mingw32.static-pkg-config --cflags --libs absl_base absl_strings) \
        -o usr/x86_64-w64-mingw32.static/bin/test-absl.exe

    Compilation (manual):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/absl-test.cpp \
        -I usr/x86_64-w64-mingw32.static/include \
        -L usr/x86_64-w64-mingw32.static/lib \
        -labsl_strings \
        -labsl_base \
        -labsl_throw_delegate \
        -o usr/x86_64-w64-mingw32.static/bin/test-absl.exe

    Notes:
        - This is only a minimal sanity check; it does not cover the full Abseil API.
        - Modify include flags or linker flags if you built Abseil with additional modules.
*/

#include <absl/strings/str_cat.h>
#include <absl/strings/string_view.h>
#include <iostream>

int main() {
    absl::string_view a = "Hello";
    absl::string_view b = "World";
    std::string c = absl::StrCat(a, ", ", b, "!");
    std::cout << c << std::endl;
    return 0;
}
