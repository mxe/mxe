/*
    This file is part of MXE. See LICENSE.md for licensing information.

    Initial test file scaffold generated using the "gsrc" tool:
    https://github.com/hkunz/git-fetcher

    Compilation (pkg-config):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/vmaf-test.cpp \
        $(./usr/bin/x86_64-w64-mingw32.static-pkg-config --cflags --libs libvmaf) \
        -o usr/x86_64-w64-mingw32.static/bin/test-vmaf.exe

    Compilation (manual):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/vmaf-test.cpp \
        -I usr/x86_64-w64-mingw32.static/include/ \
        -L usr/x86_64-w64-mingw32.static/lib/ \
        -lvmaf -pthread -lm \
        -o usr/x86_64-w64-mingw32.static/bin/test-vmaf.exe
*/

#include <iostream>
#include <libvmaf/libvmaf.h>

int main() {
    std::cout << "VMAF version: " << vmaf_version() << std::endl;

    VmafConfiguration cfg;
    cfg.log_level = VMAF_LOG_LEVEL_NONE;

    std::cout << "VmafConfiguration object created successfully!" << std::endl;
    return 0;
}
