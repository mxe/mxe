/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#ifdef _WIN32

#include <windows.h>

#ifndef _Windows
# define _Windows
#endif

#ifndef GSDLLEXPORT
# ifdef GS_STATIC_LIB
#  define GSDLLEXPORT
# else
#  define GSDLLEXPORT __declspec(dllimport)
# endif
#endif

#endif  /* _WIN32 */

#include <iapi.h>

void *minst;

int main(int argc, char *argv[])
{
    int code;

    (void)argc;
    (void)argv;

    code = gsapi_new_instance(&minst, 0);
    if (code < 0)
        return 1;

    code = gsapi_exit(minst);
    if (code < 0)
        return 1;

    gsapi_delete_instance(minst);

    return 0;
}
