/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <iostream>
#include <boost/archive/xml_oarchive.hpp>
#include <boost/thread/thread.hpp>
#include <boost/thread/tss.hpp>

boost::thread_specific_ptr<int> ptr;

// https://www.boost.org/doc/libs/1_60_0/libs/context/doc/html/context/context.html
#include <boost/context/all.hpp>
boost::context::fcontext_t fcm,fc1,fc2;

void test_thread()
{
    if (ptr.get() == 0) {
        ptr.reset(new int(0));
    }
    std::cout << "Hello, World! from thread" << std::endl;
}

void f1(intptr_t)
{
    std::cout<<"f1: entered"<<std::endl;
    std::cout<<"f1: call jump_fcontext( & fc1, fc2, 0)"<< std::endl;
    boost::context::jump_fcontext(&fc1,fc2,0);
    std::cout<<"f1: return"<<std::endl;
    boost::context::jump_fcontext(&fc1,fcm,0);
}

void f2(intptr_t)
{
    std::cout<<"f2: entered"<<std::endl;
    std::cout<<"f2: call jump_fcontext( & fc2, fc1, 0)"<<std::endl;
    boost::context::jump_fcontext(&fc2,fc1,0);
    BOOST_ASSERT(false&&!"f2: never returns");
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

    std::size_t size(8192);
    void* sp1(std::malloc(size));
    void* sp2(std::malloc(size));

    fc1=boost::context::make_fcontext(sp1,size,f1);
    fc2=boost::context::make_fcontext(sp2,size,f2);

    std::cout<<"main: call jump_fcontext( & fcm, fc1, 0)"<<std::endl;
    boost::context::jump_fcontext(&fcm,fc1,0);

    return 0;
}
