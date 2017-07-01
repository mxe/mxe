/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

// Based on: http://webdav.org/neon/doc/html/refresolve.html

#include <stdio.h>

#include <neon/ne_basic.h>

int main() {
    ne_sock_addr* addr = ne_addr_resolve("yandex.ru", 0);
    char buf[256];
    if (ne_addr_result(addr)) {
        printf("Could not resolve yandex.ru: %s\n",
               ne_addr_error(addr, buf, sizeof buf));
    } else {
        printf("yandex.ru:");
        for (const ne_inet_addr* ia = ne_addr_first(addr); ia != NULL; ia = ne_addr_next(addr)) {
            printf(" %s", ne_iaddr_print(ia, buf, sizeof buf));
        }
        printf("\n");
    }
    ne_addr_destroy(addr);
    return 0;
}
