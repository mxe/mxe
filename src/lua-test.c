/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <stdio.h>
#include <lua.h>
#include <lauxlib.h>

int main(int argc, char *argv[])
{
    lua_State *L;

    (void)argc;
    (void)argv;

    L = luaL_newstate();
    lua_close(L);
    return 0;
}
