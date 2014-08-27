#include <iostream>
#include <luabind/luabind.hpp>
#include <lua.hpp>

void greet()
{
    std::cout << "hello world!\n";
}

extern "C" int init(lua_State* L)
{
    using namespace luabind;

    open(L);

    module(L)
    [
        def("greet", &greet)
    ];

    return 0;
}

int main()
{
	lua_State* L = luaL_newstate();
	init(L);
	luaL_dostring(L, "greet()");
}
