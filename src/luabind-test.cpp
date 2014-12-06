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
    luaL_dostring(L, "greet()");
    luaL_dostring(L, "t = Test('123'); assert(t:name() == '123'");
}
