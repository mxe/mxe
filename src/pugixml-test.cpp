/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <string>
#include <pugixml.hpp>

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;
    pugi::xml_document doc;
    std::string source( "<node><child1 attr1='value1' attr2='value2'/><child2 attr1='value1'>test</child2></node>");
    pugi::xml_parse_result result = doc.load_string(source.c_str(), source.size());
    return result ? 0 : 1;
}
