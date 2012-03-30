/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <xercesc/parsers/SAXParser.hpp>

XERCES_CPP_NAMESPACE_USE

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    XMLPlatformUtils::Initialize();
    {
        SAXParser parser;
        parser.setValidationScheme(SAXParser::Val_Always);
        parser.setDoNamespaces(true);
        parser.setDoSchema(true);
        parser.setValidationSchemaFullChecking(false);
    }
    XMLPlatformUtils::Terminate();

    return 0;
}
