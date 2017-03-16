/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <libotr/proto.h>
#include <libotr/userstate.h>

int main() {
    OtrlUserState userstate;
    OTRL_INIT;
    userstate = otrl_userstate_create();
    otrl_userstate_free(userstate);
    return 0;
}
