/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <iostream>
#include <boost/archive/xml_oarchive.hpp>
#include <boost/thread/thread.hpp>
#include <boost/thread/tss.hpp>

boost::thread_specific_ptr<int> ptr;

// https://www.boost.org/doc/libs/1_76_0/libs/context/doc/html/context/context.html
#include <boost/context/fiber_fcontext.hpp>
namespace ctx=boost::context;

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

    int data=0;
    ctx::fiber f1{[&data](ctx::fiber&& f2) {
        std::cout << "f1: entered first time: " << data << std::endl;
        data+=1;
        f2=std::move(f2).resume();
        std::cout << "f1: entered second time: " << data << std::endl;
        data+=1;
        f2=std::move(f2).resume();
        std::cout << "f1: entered third time: " << data << std::endl;
        return std::move(f2);
    }};
    f1=std::move(f1).resume();
    std::cout << "f1: returned first time: " << data << std::endl;
    data+=1;
    f1=std::move(f1).resume();
    std::cout << "f1: returned second time: " << data << std::endl;
    data+=1;
    f1=std::move(f1).resume_with([&data](ctx::fiber&& f2){
        std::cout << "f2: entered: " << data << std::endl;
        data=-1;
        return std::move(f2);
    });
    std::cout << "f1: returned third time" << std::endl;
    return 0;
}
