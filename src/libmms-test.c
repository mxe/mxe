/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <libmms/mms.h>

int main()
{
  mms_t* p = mms_connect (NULL, NULL, NULL, 0);
  mms_close (p);

  return 0;
}
