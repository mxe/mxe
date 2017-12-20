/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include "p11-kit/uri.h"

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    P11KitUri *uri;

    uri = p11_kit_uri_new ();
    p11_kit_uri_parse ("http:\\example.com\test", P11_KIT_URI_FOR_ANY, uri);
    p11_kit_uri_free (uri);

    return 0;
}
