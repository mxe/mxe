/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <xxhash.h>

int main() {
    XXH32_state_t* state = XXH32_createState();
    XXH32_freeState(state);
    return 0;
}
