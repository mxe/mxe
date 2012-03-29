/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <iostream>
#include <tinyxml.h>

int main(int argc, char *argv[])
{
    if (argc != 2) {
        std::cerr << "Usage: tinyxml-test <xml-file>" << std::endl;
        return 1;
    }
    std::string fpn = argv[1];

    TiXmlDocument doc(fpn);
    if (!doc.LoadFile()) {
        std::cerr << "failed to load " << fpn << std::endl;
        return 1;
    }

    return 0;
}
