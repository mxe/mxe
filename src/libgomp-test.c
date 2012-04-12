/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <omp.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    omp_set_num_threads(4);

    #pragma omp parallel
    fprintf(stderr, "Hello from thread %d, nthreads %d\n",
            omp_get_thread_num(), omp_get_num_threads());

    return 0;
}
