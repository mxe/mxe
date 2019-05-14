/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 *
 * Taken from examples at https://fallabs.com/qdbm/spex.html
 */

#include <depot.h>
#include <stdlib.h>
#include <stdio.h>

#define NAME     "mikio"
#define NUMBER   "000-1234-5678"
#define DBNAME   "book"

int main(int argc, char **argv){
    DEPOT *depot;
    char *val;

    (void)argc;
    (void)argv;

    /* open the database */
    if(!(depot = dpopen(DBNAME, DP_OWRITER | DP_OCREAT, -1))){
        fprintf(stderr, "dpopen: %s\n", dperrmsg(dpecode));
        return 1;
    }

    /* store the record */
    if(!dpput(depot, NAME, -1, NUMBER, -1, DP_DOVER)){
        fprintf(stderr, "dpput: %s\n", dperrmsg(dpecode));
    }

    /* retrieve the record */
    if(!(val = dpget(depot, NAME, -1, 0, -1, NULL))){
        fprintf(stderr, "dpget: %s\n", dperrmsg(dpecode));
    }
    else {
        printf("Name: %s\n", NAME);
        printf("Number: %s\n", val);
        free(val);
    }

    /* close the database */
    if(!dpclose(depot)){
        fprintf(stderr, "dpclose: %s\n", dperrmsg(dpecode));
        return 1;
    }

    return 0;
}
