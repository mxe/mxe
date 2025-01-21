/* This file is part of MXE. See LICENSE.md for licensing information. */

#include <flint/arb.h>

int main(void)
{
    arb_t x, y;
    int e;
    arb_init(x);
    arb_init(y);
    arb_one(x);
    arb_set_si(y, 1);
    e = arb_equal(x, y);
    arb_clear(x);
    arb_clear(y);
    return (e) ? 0 : 1;
}
