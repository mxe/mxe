/* This file is part of mingw-cross-env.       */
/* See doc/index.html for further information. */

#include <archive.h>

int main(int argc, char *argv[])
{
    struct archive *tgz;

    (void)argc;
    (void)argv;

    tgz = archive_write_new();
    archive_write_set_compression_gzip(tgz);
    archive_write_set_format_ustar(tgz);
    archive_write_finish(tgz);

    return 0;
}
