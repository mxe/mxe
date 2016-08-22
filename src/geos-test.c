/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

#include <geos_c.h>

static void notice(const char *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    vprintf(fmt, ap);
    va_end(ap);
    printf("\n");
}

static void error(const char *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    vprintf(fmt, ap);
    va_end(ap);
    printf("\n");

    exit(1);
}

int main(int argc, char *argv[])
{
    GEOSContextHandle_t handle;

    (void)argc;
    (void)argv;

    handle = initGEOS_r(notice, error);

    printf("GEOS version: %s\n", GEOSversion());

    finishGEOS_r(handle);
    return 0;
}
