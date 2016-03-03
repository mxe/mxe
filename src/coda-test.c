/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <stdio.h>
#include <coda.h>

int main() {

  printf("Testing CODA version %s\n", libcoda_version);

  int rc = coda_init();

  if (rc) {
    printf("coda_init returned error '%d' -- '%s'", coda_errno, coda_errno_to_string(coda_errno) );
  }

  coda_done();

  return 0;
}
