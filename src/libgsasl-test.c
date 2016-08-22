/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <gsasl.h>

int main(int argc, char *argv[])
{
    Gsasl *ctx;

    (void)argc;
    (void)argv;

    if (gsasl_init(&ctx) == GSASL_OK)
    {
        (void)gsasl_client_support_p(ctx, "CRAM-MD5");
        gsasl_done(ctx);
        return 0;
    }

    return 0;
}
