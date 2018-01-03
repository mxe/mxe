/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <gumbo.h>

int main()
{
    GumboOutput *output = gumbo_parse("<blink>Hello world!</blink>");
    gumbo_destroy_output(&kGumboDefaultOptions, output);

    return 0;
}
