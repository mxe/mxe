/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <signal_protocol.h>
#include <session_builder.h>
#include <session_cipher.h>
#include <stdio.h>
#include <string.h>

int main(void)
{
    int result = 0;
    printf("Beginning of test...\\n");
    printf("0\\n");

    signal_context *global_context = NULL;
    result = signal_context_create(&global_context, NULL);
    if (result != SG_SUCCESS) return 1;
    printf("1\\n");

    signal_protocol_store_context *store_context = NULL;
    result = signal_protocol_store_context_create(&store_context, global_context);
    if (result != SG_SUCCESS) return 1;
    printf("2\\n");

    signal_protocol_session_store session_store = {
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
    };
    result = signal_protocol_store_context_set_session_store(store_context, &session_store);
    if (result != SG_SUCCESS) return 1;
    printf("3\\n");

    signal_protocol_pre_key_store pre_key_store = {
        NULL, NULL, NULL, NULL, NULL, NULL
    };
    result = signal_protocol_store_context_set_pre_key_store(store_context, &pre_key_store);
    if (result != SG_SUCCESS) return 1;
    printf("4\\n");

    signal_protocol_signed_pre_key_store signed_pre_key_store = {
        NULL, NULL, NULL, NULL, NULL, NULL
    };
    result = signal_protocol_store_context_set_signed_pre_key_store(store_context, &signed_pre_key_store);
    if (result != SG_SUCCESS) return 1;
    printf("5\\n");

    signal_protocol_identity_key_store identity_key_store = {
        NULL, NULL, NULL, NULL, NULL, NULL
    };
    result = signal_protocol_store_context_set_identity_key_store(store_context, &identity_key_store);
    if (result != SG_SUCCESS) return 1;
    printf("6\\n");

    signal_protocol_address address = {
        "+14159998888", 12, 1
    };
    session_builder *builder = NULL;
    result = session_builder_create(&builder, store_context, &address, global_context);
    if (result != SG_SUCCESS) return 1;
    printf("7\\n");

    session_cipher *cipher = NULL;
    result = session_cipher_create(&cipher, store_context, &address, global_context);
    if (result != SG_SUCCESS) return 1;
    printf("8\\n");

    session_cipher_free(cipher);
    session_builder_free(builder);
    signal_protocol_store_context_destroy(store_context);
    printf("9\\n");

    return 0;
}
