// This file is part of MXE. See LICENSE.md for licensing information.

#include <libomemo.h>
#include <libomemo_crypto.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
    char * msg_p = "<message xmlns='jabber:client' type='chat' to='alice@example.com'>"
                   "<body>hello</body>"
                   "</message>";

    printf("Original message:\n%s\n\n", msg_p);
    fflush(stdout);

    omemo_crypto_provider crypto = {
        .random_bytes_func = omemo_default_crypto_random_bytes,
        .aes_gcm_encrypt_func = omemo_default_crypto_aes_gcm_encrypt,
        .aes_gcm_decrypt_func = omemo_default_crypto_aes_gcm_decrypt,
        (void *) 0
    };

    uint32_t sid = 9178;

    omemo_message * msg_out_p;
    if (omemo_message_prepare_encryption(msg_p, sid, &crypto, OMEMO_STRIP_NONE, &msg_out_p) != 0)
        return 1;

    char * xml_out_p;
    if (omemo_message_export_encrypted(msg_out_p, OMEMO_ADD_MSG_NONE, &xml_out_p) != 0)
        return 1;

    printf("Encrypted message:\n%s\n\n", xml_out_p);
    fflush(stdout);

    return 0;
}

