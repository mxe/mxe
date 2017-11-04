/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 *
 * http://unbound.nlnetlabs.nl/documentation/libunbound-tutorial-1.html
 */

#include <stdio.h>        /* for printf */
#include <winsock2.h>   /* for inet_ntoa */
#include <unbound.h>    /* unbound API */

int main(void)
{
    struct ub_ctx* ctx;
    struct ub_result* result;
    int retval;

    /* create context */
    ctx = ub_ctx_create();
    if(!ctx) {
        printf("error: could not create unbound context\n");
        return 1;
    }

    /* query for webserver */
    retval = ub_resolve(ctx, "www.nlnetlabs.nl",
        1 /* TYPE A (IPv4 address) */,
        1 /* CLASS IN (internet) */, &result);
    if(retval != 0) {
        printf("resolve error: %s\n", ub_strerror(retval));
        return 1;
    }

    /* show first result */
    if(result->havedata)
        printf("The address is %s\n",
            inet_ntoa(*(struct in_addr*)result->data[0]));

    ub_resolve_free(result);
    ub_ctx_delete(ctx);
    return 0;
}
