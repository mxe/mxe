#include <iostream>
#include <hunspell.hxx>

int main(int argc, char *argv[])
{
    Hunspell h("hunspell-test.aff", "hunspell-test.dic");

    (void)argc;
    (void)argv;

    if (h.spell("Hello") == 0)
    {
        std::cerr << "Error: hunspell marked correct word as wrong" << std::endl;
    }
    if (h.spell("wrld") != 0)
    {
        std::cerr << "Error: hunspell marked wrong word as correct" << std::endl;
    }
    
    return 0;
}
