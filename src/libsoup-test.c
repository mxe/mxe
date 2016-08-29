/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <libsoup/soup.h>

int main()
{
    SoupServer *server;
    GError *error;

    server = soup_server_new (SOUP_SERVER_SERVER_HEADER, "simple-httpd ", SOUP_SERVER_TLS_CERTIFICATE, NULL, NULL);
    soup_server_listen_all (server, 1234, SOUP_SERVER_LISTEN_HTTPS, &error);

    return 0;
}
