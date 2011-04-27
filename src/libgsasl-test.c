/* This file is part of mingw-cross-env.       */
/* See doc/index.html for further information. */

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
