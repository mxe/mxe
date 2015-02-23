/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <aubio/aubio.h>

int main(void)
{
    fvec_t *vec = new_fvec(20);

    fvec_ones(vec);
    if (vec->data[0] != 1.)
        return 1;

    fvec_zeros(vec);
    if (vec->data[0] != 0.)
        return 1;

    fvec_print(vec);

    del_fvec(vec);

    return 0;
}

