/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <stdint.h>
#include <dca.h>

int main(int argc, char *argv[])
{
    dca_state_t *state;

    (void)argc;
    (void)argv;

    state = dca_init(0);
    if (!state) {
        return 1;
    }

    dca_free(state);
    return 0;
}
