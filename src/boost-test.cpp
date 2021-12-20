/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */
 

// Boost.Context Example
//          Copyright Oliver Kowalke 2016.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

#include <cstdlib>
#include <iostream>
#include <boost/archive/xml_oarchive.hpp>
#include <boost/thread/thread.hpp>
#include <boost/thread/tss.hpp>

boost::thread_specific_ptr<int> ptr;

#include <boost/context/fiber.hpp>

namespace ctx = boost::context;

class moveable {
public:
    int     value;

    moveable() :
        value( -1) {
        }

    moveable( int v) :
        value( v) {
        }

    moveable( moveable && other) {
        std::swap( value, other.value);
        }

    moveable & operator=( moveable && other) {
        if ( this == & other) return * this;
        value = other.value;
        other.value = -1;
        return * this;
    }

    moveable( moveable const& other) = delete;
    moveable & operator=( moveable const& other) = delete;
};
void test_thread()
{
    if (ptr.get() == 0) {
        ptr.reset(new int(0));
    }
    std::cout << "Hello, World! from thread" << std::endl;
}

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    boost::archive::xml_oarchive oa(std::cout);
    std::string s = "\n\n    Hello, World!\n\n";
    oa << BOOST_SERIALIZATION_NVP(s);

    boost::thread thrd(test_thread);
    thrd.join();

    moveable data{ 1 };
    ctx::fiber f{ std::allocator_arg, ctx::fixedsize_stack{},
                     [&data](ctx::fiber && f){
                        std::cout << "entered first time: " << data.value << std::endl;
                        data = std::move( moveable{ 3 });
                        f = std::move( f).resume();
                        std::cout << "entered second time: " << data.value << std::endl;
                        data = std::move( moveable{});
                        return std::move( f);
                     }};
    f = std::move( f).resume();
    std::cout << "returned first time: " << data.value << std::endl;
    data.value = 5;
    f = std::move( f).resume();
    std::cout << "returned second time: " << data.value << std::endl;
    std::cout << "main: done" << std::endl;
    return EXIT_SUCCESS;
}
