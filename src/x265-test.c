// This file is part of MXE. See LICENSE.md for licensing information.

#include <x265.h>

int main(void)
{
  int rv = 0;

  x265_param *param = x265_param_alloc();
  x265_param_default(param);
  x265_encoder *encoder = x265_encoder_open(param);

  if (x265_param_apply_profile(param, "main444-12-intra") != 0)
    rv = 1;

  x265_encoder_close(encoder);
  x265_param_free(param);
  x265_cleanup();

  return rv;
}
