/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <iostream>
#include <fstream>
#include <hunspell.hxx>

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    std::ofstream dic ("hunspell-test.dic");
    dic << "2\nHello\nWorld";
    dic.close();
    std::ofstream aff ("hunspell-test.aff");
    aff << "SET UTF-8\nTRY loredWH\nMAXDIFF 1";
    aff.close();
    Hunspell h("hunspell-test.aff", "hunspell-test.dic");

    if (h.spell("Hello") == 0)
    {
        std::cerr << "Error: hunspell marked correct word as wrong" << std::endl;
    }
    if (h.spell("wrld") != 0)
    {
        std::cerr << "Error: hunspell marked wrong word as correct" << std::endl;
    }

    char ** result;
    int n = h.suggest(&result, "ell");
    for (int i = 0; i < n; i++) std::cout << result[i];

    return 0;
}
