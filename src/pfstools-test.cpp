/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <pfs/pfs.h>

int main(int argc, char *argv[])
{
    pfs::DOMIO pfsio;
    pfs::Frame* frame;

    (void)argc;
    (void)argv;

    frame = pfsio.createFrame(10, 10);
    pfsio.freeFrame(frame);

    return 0;
}
