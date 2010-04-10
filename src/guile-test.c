/* This file is part of mingw-cross-env.       */
/* See doc/index.html for further information. */

#include <libguile.h>

static void inner_main(void *data, int argc, char *argv[])
{
    (void)data;
    (void)argc;
    (void)argv;
    scm_c_eval_string("(display \"Hello World!\\n\")");
}

int main(int argc, char *argv[])
{
    scm_boot_guile(argc, argv, inner_main, NULL);
    return 0;
}
