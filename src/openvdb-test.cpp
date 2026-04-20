/*
    This file is part of MXE. See LICENSE.md for licensing information.

    Initial test file scaffold generated using the "gsrc" tool:
    https://github.com/hkunz/git-fetcher

    Compilation (pkg-config):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/openvdb-test.cpp \
        $(./usr/bin/x86_64-w64-mingw32.static-pkg-config --cflags --libs openvdb) \
        -o usr/x86_64-w64-mingw32.static/bin/test-openvdb.exe

    Compilation (manual):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/openvdb-test.cpp \
        -I usr/x86_64-w64-mingw32.static/include \
        -L usr/x86_64-w64-mingw32.static/lib \
        -lopenvdb \
        -o usr/x86_64-w64-mingw32.static/bin/test-openvdb.exe
*/

#include <openvdb/openvdb.h>
#include <iostream>

int main()
{
    try {
        // Required: initialize OpenVDB
        openvdb::initialize();

        // Create an empty float grid
        openvdb::FloatGrid::Ptr grid = openvdb::FloatGrid::create();

        // Get accessor to modify voxels
        openvdb::FloatGrid::Accessor accessor = grid->getAccessor();

        // Set a voxel value
        openvdb::Coord xyz(1, 2, 3);
        accessor.setValue(xyz, 5.0f);

        // Read it back
        float value = accessor.getValue(xyz);

        std::cout << "Voxel value at (1,2,3): " << value << std::endl;

        if (value == 5.0f) {
            std::cout << "OpenVDB test PASSED" << std::endl;
            return 0;
        } else {
            std::cout << "OpenVDB test FAILED" << std::endl;
            return 1;
        }
    }
    catch (const std::exception &e) {
        std::cerr << "Exception: " << e.what() << std::endl;
        return 1;
    }
}