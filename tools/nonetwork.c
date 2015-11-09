// nonetwork, break standard network functions using LD_PRELOAD
// Source: https://github.com/starius/nonetwork
// Copyright (C) 2015 Boris Nagaev
// License: MIT

#include <errno.h>

int connect(int sock, const void *addr, unsigned int len) {
    errno = 13; // EACCES, Permission denied
    return -1;
}

void *gethostbyname(const char *name) {
    return 0;
}

int getaddrinfo(const char *node, const char *service,
                const void *hints,
                void **res) {
    return -4; // EAI_FAIL
}

void freeaddrinfo(void *res) {
}

int getnameinfo(const void * sa,
                unsigned int salen, char * host,
                unsigned int hostlen, char * serv,
                unsigned int servlen, int flags) {
    return -4; // EAI_FAIL
}

struct hostent *gethostbyaddr(const void *addr, unsigned int len,
                              int type) {
    return 0;
}
