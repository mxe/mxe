/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <zip.h>
#include <stdlib.h>

/* Adapted from freedink/src/SDL_rwops_libzip.c */
int main(int argc, char* argv[])
{
    struct zip* zarchive;
    int errorp = 0;

    (void)argc;
    (void)argv;

    zarchive = zip_open("idontexist.zip", ZIP_CHECKCONS, &errorp);
    if (errorp != 0)
        {
            char *errorbuf = NULL;
            int len = 1;
            errorbuf = malloc(len);
            len = zip_error_to_str(errorbuf, len, errorp, errno);
            errorbuf = realloc(errorbuf, len + 1);
            len = zip_error_to_str(errorbuf, len, errorp, errno);
            fprintf(stderr, "zip_open: %s\n", errorbuf);
            free(errorbuf);
        }
    else
        {
            struct zip_file* zfile;
            zfile = zip_fopen(zarchive, "fichier.txt", 0);
            if (zfile == NULL)
                {
                    fprintf(stderr, "zip_open: %s\n", zip_strerror(zarchive));
                    zip_close(zarchive);
                }
        }

    return 0;
}
