/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <string>
#include <iostream>
#include <vigra/imageinfo.hxx>

using namespace vigra;

int main(int argc, char *argv[])
{
    std::string formats = vigra::impexListFormats();

    std::cout << "Supported formats: " << formats << std::endl;

    return formats.length() > 0;
}
