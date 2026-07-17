/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <msquic.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
    const QUIC_API_TABLE *MsQuic = NULL;
    QUIC_STATUS Status;
    HQUIC Registration = NULL;
    HQUIC Configuration = NULL;

    (void)argc;
    (void)argv;

    /* Open the MsQuic library */
    Status = MsQuicOpen2(&MsQuic);
    if (QUIC_FAILED(Status)) {
        fprintf(stderr, "MsQuicOpen2 failed: 0x%lx\n", (unsigned long)Status);
        return 1;
    }

    /* Create a registration for the app's connections/listeners */
    const QUIC_REGISTRATION_CONFIG RegConfig = { "mxe-test", QUIC_EXECUTION_PROFILE_LOW_LATENCY };
    Status = MsQuic->RegistrationOpen(&RegConfig, &Registration);
    if (QUIC_FAILED(Status)) {
        fprintf(stderr, "RegistrationOpen failed: 0x%lx\n", (unsigned long)Status);
        MsQuicClose(MsQuic);
        return 1;
    }

    /* Create a configuration (for client/server settings) */
    QUIC_SETTINGS Settings = {0};
    Settings.IdleTimeoutMs = 10000;
    Settings.IsSet.IdleTimeoutMs = TRUE;
    Settings.PeerBidiStreamCount = 1;
    Settings.IsSet.PeerBidiStreamCount = TRUE;

    QUIC_CREDENTIAL_CONFIG CredConfig;
    memset(&CredConfig, 0, sizeof(CredConfig));
    CredConfig.Type = QUIC_CREDENTIAL_TYPE_NONE;

    Status = MsQuic->ConfigurationOpen(
        Registration,
        NULL,
        0,
        &Settings,
        sizeof(Settings),
        NULL,
        &Configuration);
    if (QUIC_FAILED(Status)) {
        fprintf(stderr, "ConfigurationOpen failed: 0x%lx\n", (unsigned long)Status);
        MsQuic->RegistrationClose(Registration);
        MsQuicClose(MsQuic);
        return 1;
    }

    /* Load credentials - this tests the TLS integration */
    Status = MsQuic->ConfigurationLoadCredential(Configuration, &CredConfig);
    if (QUIC_FAILED(Status)) {
        fprintf(stderr, "ConfigurationLoadCredential failed: 0x%lx\n", (unsigned long)Status);
        MsQuic->ConfigurationClose(Configuration);
        MsQuic->RegistrationClose(Registration);
        MsQuicClose(MsQuic);
        return 1;
    }

    printf("MsQuic library test successful!\n");

    /* Clean up in reverse order */
    MsQuic->ConfigurationClose(Configuration);
    MsQuic->RegistrationClose(Registration);
    MsQuicClose(MsQuic);

    return 0;
}
