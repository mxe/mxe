/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#ifdef __WIN32__
#include <windows.h>
#endif
#include <iapi.h>

int main(int argc, char *argv[])
{
    int code;
    void *minst = NULL;

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
