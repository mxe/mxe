/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <openssl/ssl.h>
#include <openssl/crypto.h>
#include <openssl/err.h>

int main(int argc, char *argv[])
{
    SSL_CTX *ctx;

    (void)argc;
    (void)argv;

    /* Initialize OpenSSL */
    OPENSSL_init_ssl(0, NULL);

    /* Create SSL context - QuicTLS provides QUIC callback APIs
     * that are used by libraries like MsQuic */
    ctx = SSL_CTX_new(TLS_client_method());
    if (ctx == NULL) {
        return 1;
    }

    /* Verify TLS 1.3 is available (required for QUIC) */
    if (SSL_CTX_set_min_proto_version(ctx, TLS1_3_VERSION) != 1) {
        SSL_CTX_free(ctx);
        return 1;
    }

    SSL_CTX_free(ctx);
    return 0;
}
