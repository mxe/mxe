/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

/* Based on: https://libcddb.sourceforge.io/tutorial.html */

#include <stdio.h>

#include <cddb/cddb.h>

int main() {
    cddb_track_t *track = NULL;
    track = cddb_track_new();
    if (track == NULL) {
            fprintf(stderr, "out of memory, unable to create track");
    }
    cddb_track_destroy(track);
    return 0;
}
