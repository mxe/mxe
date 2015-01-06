/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <archive.h>

int main(int argc, char *argv[])
{
    struct archive *tgz;

    (void)argc;
    (void)argv;

    tgz = archive_write_new();
    archive_write_set_options(tgz, "gzip=9");
    archive_write_set_format_ustar(tgz);
    archive_write_free(tgz);

    return 0;
}
