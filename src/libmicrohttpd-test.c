/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <stdio.h>
#include <sys/types.h>
#include <microhttpd.h>

#define PORT 8888

int answer_to_connection (void *cls, struct MHD_Connection *connection,
                          const char *url,
                          const char *method, const char *version,
                          const char *upload_data,
                          size_t *upload_data_size, void **con_cls)
{
  const char *page  = "<html><body>Hello, browser!</body></html>";

  struct MHD_Response *response;
  int ret;

  response = MHD_create_response_from_buffer (strlen (page),
                                            (void*) page, MHD_RESPMEM_PERSISTENT);
  ret = MHD_queue_response (connection, MHD_HTTP_OK, response);
  MHD_destroy_response (response);

  return ret;
}

int main (int argc, char *const *argv)
{
  (void)argc;
  (void)argv;

  struct MHD_Daemon *daemon;

  daemon = MHD_start_daemon (MHD_USE_THREAD_PER_CONNECTION, PORT, NULL, NULL,
                             &answer_to_connection, NULL, MHD_OPTION_END);
  if (NULL == daemon) return 1;

  getchar ();

  MHD_stop_daemon (daemon);
  return 0;
}
