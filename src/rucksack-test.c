/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <rucksack/rucksack.h>

int main(int argc, char * argv[]) {
    (void)argc;
    struct RuckSackBundle *bundle;
    rucksack_bundle_open(argv[1], &bundle);
    rucksack_bundle_close(bundle);
    return 0;
}
