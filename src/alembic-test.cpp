/*
    This file is part of MXE. See LICENSE.md for licensing information.

    Initial test file scaffold generated using the "gsrc" tool:
    https://github.com/hkunz/git-fetcher

    Compilation (pkg-config):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/alembic-test.cpp \
        $(./usr/bin/x86_64-w64-mingw32.static-pkg-config --cflags --libs alembic) \
        -o usr/x86_64-w64-mingw32.static/bin/test-alembic.exe

    Compilation (manual):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/alembic-test.cpp \
        -I usr/x86_64-w64-mingw32.static/include \
        -L usr/x86_64-w64-mingw32.static/lib \
        -lAlembic \
        -o usr/x86_64-w64-mingw32.static/bin/test-alembic.exe
*/

#include <Alembic/Abc/All.h>
#include <Alembic/AbcGeom/All.h>
#include <Alembic/AbcCoreOgawa/All.h>
#include <iostream>
#include <fstream>

int main()
{
    const std::string filename = "test.abc";

    std::cout << "Creating Alembic archive: " << filename << std::endl;

    Alembic::Abc::OArchive archive(
        Alembic::AbcCoreOgawa::WriteArchive(),
        filename
    );

    Alembic::AbcGeom::OXform xform(
        Alembic::Abc::OObject(archive, Alembic::Abc::kTop),
        "root"
    );

    std::cout << "Created root Xform object in archive." << std::endl;

    if (std::ifstream(filename).good())
        std::cout << "Archive file exists: " << filename << std::endl;
    else
        std::cout << "Archive file NOT found!" << std::endl;

    std::cout << "Alembic test finished successfully." << std::endl;

    return 0;
}
