#include <iostream>
#include <cpp/poppler-version.h>
#include <cpp/poppler-document.h>

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    std::cout << "Poppler version: " << poppler::version_string() << std::endl;
    poppler::document::load_from_file("a.pdf");

    return 0;
}
