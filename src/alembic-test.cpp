/*
    Alembic Test Program
    https://www.alembic.io/
    License: BSD (see Alembic LICENSE)

    Example program demonstrating use of the Alembic C++ library and linked
    libraries (Imath, HDF5, AlembicCoreOgawa) on Windows via MXE.

    To compile with MXE for Windows:

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        -I usr/x86_64-w64-mingw32.static/include \
        src/alembic-test.cpp \
        -L usr/x86_64-w64-mingw32.static/lib \
        -lAlembic \
        -lImath-3_2 \
        -lhdf5 \
        -lz \
        -o test-alembic.exe

    This program verifies that Alembic and its dependencies are correctly
    built and linked.
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
