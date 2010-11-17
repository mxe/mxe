/* This file is part of mingw-cross-env.       */
/* See doc/index.html for further information. */

#include <iostream>
#include <tinyxml.h>

using namespace std;

// ----------------------------------------------------------------------
// STDOUT dump and indenting utility functions
// ----------------------------------------------------------------------
const unsigned int NUM_INDENTS_PER_SPACE=2;

const char * getIndent( unsigned int numIndents )
{
    static const char * pINDENT="                                      + ";
    static const unsigned int LENGTH=strlen( pINDENT );
    unsigned int n=numIndents*NUM_INDENTS_PER_SPACE;
    if ( n > LENGTH ) n = LENGTH;

    return &pINDENT[ LENGTH-n ];
}

// same as getIndent but no "+" at the end
const char * getIndentAlt( unsigned int numIndents )
{
    static const char * pINDENT="                                        ";
    static const unsigned int LENGTH=strlen( pINDENT );
    unsigned int n=numIndents*NUM_INDENTS_PER_SPACE;
    if ( n > LENGTH ) n = LENGTH;

    return &pINDENT[ LENGTH-n ];
}

int dump_attribs_to_stdout(TiXmlElement* pElement, unsigned int indent)
{
    if ( !pElement ) return 0;

    TiXmlAttribute* pAttrib=pElement->FirstAttribute();
    int i=0;
    int ival;
    double dval;
    const char* pIndent=getIndent(indent);
    printf("\n");
    while (pAttrib)
    {
        printf( "%s%s: value=[%s]", pIndent, pAttrib->Name(), pAttrib->Value());

        if (pAttrib->QueryIntValue(&ival)==TIXML_SUCCESS)    printf( " int=%d", ival);
        if (pAttrib->QueryDoubleValue(&dval)==TIXML_SUCCESS) printf( " d=%1.1f", dval);
        printf( "\n" );
        i++;
        pAttrib=pAttrib->Next();
    }
    return i;
}

void dump_to_stdout(TiXmlNode* pParent, unsigned int indent = 0)
{
    if (!pParent)
        return;

    TiXmlNode* pChild;
    TiXmlText* pText;
    int t = pParent->Type();
    printf("%s", getIndent(indent));
    int num;

    switch (t) {
    case TiXmlNode::TINYXML_DOCUMENT:
        printf("Document");
        break;

    case TiXmlNode::TINYXML_ELEMENT:
        printf("Element [%s]", pParent->Value());
        num=dump_attribs_to_stdout(pParent->ToElement(), indent+1);
        switch(num) {
            case 0:  printf(" (No attributes)"); break;
            case 1:  printf("%s1 attribute", getIndentAlt(indent)); break;
            default: printf("%s%d attributes", getIndentAlt(indent), num); break;
        }
        break;

    case TiXmlNode::TINYXML_COMMENT:
        printf("Comment: [%s]", pParent->Value());
        break;

    case TiXmlNode::TINYXML_UNKNOWN:
        printf("Unknown" );
        break;

    case TiXmlNode::TINYXML_TEXT:
        pText = pParent->ToText();
        printf("Text: [%s]", pText->Value() );
        break;

    case TiXmlNode::TINYXML_DECLARATION:
        printf("Declaration" );
        break;
    default:
        break;
    }
    printf("\n");
    for ( pChild = pParent->FirstChild(); pChild != 0; pChild = pChild->NextSibling())
    {
        dump_to_stdout( pChild, indent+1 );
    }
}
//=============================================================================
int main(int argc, char *argv[])
{
    if (argc <= 1) {
        cout << "Usage: tinyxml-test <xml-file>" << endl;
        exit(1);
    }

    string fpn(argv[1]);
    TiXmlDocument doc(fpn);
    if (!doc.LoadFile()) {
        cerr << "failed to load " << fpn << endl;
        exit(1);
    }

    dump_to_stdout(&doc);

    return 0;
}
//=============================================================================
