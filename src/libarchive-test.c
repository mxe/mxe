/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <archive.h>

int main(int argc, char *argv[])
{
    struct archive *tgz;
    struct archive *zip;

    (void)argc;
    (void)argv;

    tgz = archive_write_new();
    archive_write_set_options(tgz, "gzip=9");
    archive_write_set_format_ustar(tgz);
    archive_write_free(tgz);

    zip = archive_read_new();
    archive_read_support_format_zip(zip);

    return 0;
}
