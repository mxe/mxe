/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <mxml.h>

int main(int argc, char *argv[])
{
    mxml_node_t *tree;

    (void)argc;
    (void)argv;

    tree = mxmlLoadString(NULL,
                          "<?xml version=\"1.0\"?>\n"
                          "<test/>\n",
                          MXML_TEXT_CALLBACK);

    mxmlDelete(tree);

    return 0;
}
