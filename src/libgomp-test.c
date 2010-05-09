/* This file is part of mingw-cross-env.       */
/* See doc/index.html for further information. */

#include <omp.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    #pragma omp parallel
    printf("Hello from thread %d, nthreads %d\n",
           omp_get_thread_num(), omp_get_num_threads());

    return 0;
}
