// nonetwork, break standard network functions using LD_PRELOAD
// Source: https://github.com/starius/nonetwork
// Copyright (C) 2015 Boris Nagaev
// License: MIT

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

static void print_message() {
    if(getenv("MXE_SILENT_NO_NETWORK")) {
    } else {
        fflush(stderr);
        fprintf(stderr, "\nDon't use network from MXE build rules!\n");
        fprintf(stderr, "\tSilent mode for scripts reading stderr into variables:\n");
        fprintf(stderr, "\t\tMXE_SILENT_NO_NETWORK= make ...\n");
        fflush(stderr);
    }
}

int connect(int sock, const void *addr, unsigned int len) {
    print_message();
    errno = 13; // EACCES, Permission denied
    return -1;
}

void *gethostbyname(const char *name) {
    print_message();
    return 0;
}

int getaddrinfo(const char *node, const char *service,
                const void *hints,
                void **res) {
    print_message();
    return -4; // EAI_FAIL
}

void freeaddrinfo(void *res) {
    print_message();
}

int getnameinfo(const void * sa,
                unsigned int salen, char * host,
                unsigned int hostlen, char * serv,
                unsigned int servlen, int flags) {
    print_message();
    return -4; // EAI_FAIL
}

struct hostent *gethostbyaddr(const void *addr, unsigned int len,
                              int type) {
    print_message();
    return 0;
}
