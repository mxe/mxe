/* This file is part of mingw-cross-env.       */
/* See doc/index.html for further information. */

#include <stdio.h>
#include <gsl/gsl_sf_bessel.h>

int main(int argc, char *argv[]) 
{
    double x, y;

    (void)argc;
    (void)argv;

    x = 5.0;
    y = gsl_sf_bessel_J0 (x);
    printf ("J0(%g) = %.18e\n", x, y);
    return 0;
}
