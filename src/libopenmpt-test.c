#include <libopenmpt/libopenmpt.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;
    printf("libopenmpt version: %s\n", openmpt_get_string("library_version"));
    return 0;
}
