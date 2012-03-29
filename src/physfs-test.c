/*
 * This file is part of MXE.
 * See index.html for further information.
 *
 * This is a slightly modified version of:
 * test/physfs_test.c
 */

#include "physfs.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    PHYSFS_Version compiled;
    PHYSFS_VERSION(&compiled);

    printf("Compiled against PhysicsFS version %d.%d.%d\n\n",
        (int) compiled.major, (int) compiled.minor, (int) compiled.patch);

    const PHYSFS_ArchiveInfo **rc;
    const PHYSFS_ArchiveInfo **i;

    rc = PHYSFS_supportedArchiveTypes();
    printf("Supported archive types:\n");
    if (*rc == NULL)
        printf(" * Apparently, NONE!\n");
    else
    {
        for (i = rc; *i != NULL; i++)
        {
            printf(" * %s: %s\n    Written by %s.\n    %s\n",
                    (*i)->extension, (*i)->description,
                    (*i)->author, (*i)->url);
        } /* for */
    } /* else */

    return 0;
}
