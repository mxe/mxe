/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <stdio.h>
#include <pthread.h>

#define N 4

void *thread_fn(void *p)
{
    const int *arg = p;
    fprintf(stderr, "Hello from thread %d, nthreads %d\n", *arg, N);
    return NULL;
}

int main(int argc, char *argv[])
{
    pthread_t threads[N];
    int args[N];
    int i;

    (void)argc;
    (void)argv;

    for (i = 0; i < N; i++) {
        args[i] = i;
        if (pthread_create(threads + i, NULL, thread_fn, args + i) != 0) {
            return 1;
        }
    }

    for (i = 0; i < N; i++) {
        if (pthread_join(threads[i], NULL) != 0) {
            return 2;
        }
    }

    return 0;
}
