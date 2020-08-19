/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <re2/re2.h>

int main()
{
    std::string text("This is a test.");
    RE2 regex(" [aeiou] ");

    if (RE2::PartialMatch(text, regex))
        return 0;

    return 1;
}
