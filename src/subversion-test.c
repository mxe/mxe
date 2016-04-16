#include <svn_cmdline.h>

int main (void) {
  if (svn_cmdline_init("mxe_test", stderr) != EXIT_SUCCESS)
    return EXIT_FAILURE;
  return EXIT_SUCCESS;
}

