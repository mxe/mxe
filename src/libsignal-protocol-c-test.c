/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <signal_protocol.h>
#include <key_helper.h>
#include <session_builder.h>
#include <session_cipher.h>
#include <protocol.h>
#include <stdio.h>
#include <string.h>

int main(void)
{
    int result = 0;

    // Library initialization

    signal_context *global_context = NULL;
    result = signal_context_create(&global_context, NULL);
    if (result != SG_SUCCESS) return 1;

    // Client install time

    uint32_t registration_id = 0;
    result = signal_protocol_key_helper_generate_registration_id(&registration_id, 0, global_context);
    if (result != SG_SUCCESS) return 1;
    printf("registration_id = %i\n", registration_id);
    fflush(stdout);

    ratchet_identity_key_pair *identity_key_pair = NULL;
    result = signal_protocol_key_helper_generate_identity_key_pair(&identity_key_pair, global_context);
    if (result != SG_SUCCESS) return 1;

    signal_protocol_key_helper_pre_key_list_node *pre_keys_head = NULL;
    result = signal_protocol_key_helper_generate_pre_keys(&pre_keys_head, 13, 100, global_context);
    if (result != SG_SUCCESS) return 1;

    session_signed_pre_key *signed_pre_key = NULL;
    result = signal_protocol_key_helper_generate_signed_pre_key(&signed_pre_key, identity_key_pair, 5, 1482458501, global_context);
    if (result != SG_SUCCESS) return 1;

    // Create the data store context, and add all the callbacks to it

    signal_protocol_store_context *store_context = NULL;
    result = signal_protocol_store_context_create(&store_context, global_context);
    if (result != SG_SUCCESS) return 1;

    signal_protocol_session_store session_store = {
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
    };
    result = signal_protocol_store_context_set_session_store(store_context, &session_store);
    if (result != SG_SUCCESS) return 1;

    signal_protocol_pre_key_store pre_key_store = {
        NULL, NULL, NULL, NULL, NULL, NULL
    };
    result = signal_protocol_store_context_set_pre_key_store(store_context, &pre_key_store);
    if (result != SG_SUCCESS) return 1;

    signal_protocol_signed_pre_key_store signed_pre_key_store = {
        NULL, NULL, NULL, NULL, NULL, NULL
    };
    result = signal_protocol_store_context_set_signed_pre_key_store(store_context, &signed_pre_key_store);
    if (result != SG_SUCCESS) return 1;

    signal_protocol_identity_key_store identity_key_store = {
        NULL, NULL, NULL, NULL, NULL, NULL
    };
    result = signal_protocol_store_context_set_identity_key_store(store_context, &identity_key_store);
    if (result != SG_SUCCESS) return 1;

    // Instantiate a session_builder for a recipient address

    signal_protocol_address address = {
        "+14159998888", 12, 1
    };
    session_builder *builder = NULL;
    result = session_builder_create(&builder, store_context, &address, global_context);
    if (result != SG_SUCCESS) return 1;

    // Create the session cipher and encrypt the message

    session_cipher *cipher = NULL;
    result = session_cipher_create(&cipher, store_context, &address, global_context);
    if (result != SG_SUCCESS) return 1;

    const char *message = "Kill all humans!!!11100...........";
    const size_t message_len = strlen(message);
    ciphertext_message *encrypted_message = NULL;
    result = session_cipher_encrypt(cipher, (uint8_t*)message, message_len, &encrypted_message);
    if (result != SG_SUCCESS) return 1;

    // Get the serialized content and deliver it

    signal_buffer *serialized = ciphertext_message_get_serialized(encrypted_message);
    printf("message:\n%.*s\n", (int)signal_buffer_len(serialized), signal_buffer_data(serialized));
    fflush(stdout);

    // Cleanup

    SIGNAL_UNREF(encrypted_message);
    session_cipher_free(cipher);
    session_builder_free(builder);
    signal_protocol_store_context_destroy(store_context);

    return 0;
}
