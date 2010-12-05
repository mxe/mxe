/* This file is part of mingw-cross-env.       */
/* See doc/index.html for further information. */

#include <stdio.h>
#include <lua.h>
#include <lauxlib.h>

int main (int argc, char **argv) {
    (void)argc;
    (void)argv;
    
    lua_State *L = lua_open();
    lua_close(L);
    return 0;
}
