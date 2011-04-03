/* This file is part of mingw-cross-env.       */
/* See doc/index.html for further information. */

#include <ass/ass.h>

int main(void)
{
    ASS_Library *handle = ass_library_init();
    ass_library_done(handle);
    return 0;
}
