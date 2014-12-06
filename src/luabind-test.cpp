#include <cassert>
#include <iostream>
#include <string>

#include <luabind/luabind.hpp>
#include <lua.hpp>

void greet()
{
    std::cout << "hello world!\n";
}

class Test {
public:
    Test(std::string name):
        name_(name) {
    }

    std::string name() const {
        return name_;
    }

private:
    std::string name_;
};

extern "C" int init(lua_State* L)
{
    using namespace luabind;

    open(L);

    module(L)
    [
        def("greet", &greet),
        class_<Test>("Test")
            .def(constructor<std::string>())
            .def("name", &Test::name)
    ];

    return 0;
}

int main()
{
    lua_State* L = luaL_newstate();
    init(L);
    // hello world
    luaL_dostring(L, "greet()");
    // class
    luaL_dostring(L, "t = Test('123'); assert(t:name() == '123'");
    // iterate Lua table in C++
    luaL_dostring(L, "list123 = {1, 2, 3}");
    int sum = 0;
    lua_getglobal(L, "list123");
    luabind::object list123(luabind::from_stack(L, -1));
    lua_pop(L, 1);
    for (luabind::iterator it(list123), end; it != end; ++it) {
        luabind::object item = *it;
        sum += luabind::object_cast<int>(item);
    }
    assert(sum == 6);
}
