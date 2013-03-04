/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <stdlib.h>
#include <stdio.h>
#include <libguile.h>

# ifdef __STRICT_ANSI__
int putenv (char *);
# endif

static void inner_main(void *data, int argc, char *argv[])
{
    (void)data;
    (void)argc;
    (void)argv;
    scm_c_eval_string("(display \"Hello World!\\n\")");
}

int main(int argc, char *argv[])
{
    char guile_load_path[40];
    snprintf(guile_load_path, sizeof guile_load_path, \
        "GUILE_LOAD_PATH=..\\share\\guile\\%s", GUILE_MAJOR_MINOR);
    putenv(guile_load_path);
    scm_boot_guile(argc, argv, inner_main, NULL);
    return 0;
}
