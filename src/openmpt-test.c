/*
    This file is part of MXE. See LICENSE.md for licensing information.

    Initial test file scaffold generated using the "gsrc" tool:
    https://github.com/hkunz/git-fetcher

    Compilation (pkg-config):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/openmpt-test.c \
        $(./usr/bin/x86_64-w64-mingw32.static-pkg-config --cflags --libs libopenmpt) \
        -lmpg123 -lz -lshlwapi \
        -o usr/x86_64-w64-mingw32.static/bin/test-openmpt.exe

    Compilation (manual):

    ./usr/bin/x86_64-w64-mingw32.static-gcc \
        src/openmpt-test.c \
        -I usr/x86_64-w64-mingw32.static/include \
        -L usr/x86_64-w64-mingw32.static/lib \
        -lopenmpt -lvorbisfile -lvorbis -logg -lmpg123 -lz -lshlwapi \
        -lstdc++ \
        -o usr/x86_64-w64-mingw32.static/bin/test-openmpt.exe

    What this program does:

    - Loads a tracker music file using libopenmpt
    - Decodes a small block of audio (PCM samples)
    - Prints basic info (e.g. title)
    - Verifies that libopenmpt is correctly linked and working

    Supported input formats:

    - .xm  (FastTracker II)
    - .it  (Impulse Tracker)
    - .s3m (Scream Tracker 3)
    - .mod (Amiga / ProTracker)
    - .mptm and other libopenmpt-supported modules

    Usage:
        test-libopenmpt.exe <module_file>

    Example:
        test-libopenmpt.exe song.xm

    Sample files:
    https://modarchive.org/
    Example: https://api.modarchive.org/downloads.php?moduleid=49757
*/

#include <libopenmpt/libopenmpt.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <module file>\n", argv[0]);
        return 1;
    }

    FILE *f = fopen(argv[1], "rb");
    if (!f) return 1;

    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    fseek(f, 0, SEEK_SET);

    unsigned char *data = (unsigned char*)malloc(size);
    fread(data, 1, size, f);
    fclose(f);

    int error = 0;
    const char *error_message = NULL;

    openmpt_module *mod = openmpt_module_create_from_memory2(
        data,
        (size_t)size,
        NULL,   // logfunc
        NULL,   // loguser
        NULL,   // errfunc
        NULL,   // erruser
        &error,
        &error_message,
        NULL    // initial_ctls
    );

    free(data);

    if (!mod) {
        fprintf(stderr, "Failed: %s\n", error_message ? error_message : "unknown");
        return 1;
    }

    printf("Title: %s\n",
        openmpt_module_get_metadata(mod, "title"));

    int16_t buffer[1024 * 2];

    size_t frames = openmpt_module_read_interleaved_stereo(
        mod,
        48000,
        1024,
        buffer
    );

    printf("Decoded frames: %zu\n", frames);

    openmpt_module_destroy(mod);
    return 0;
}
