/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <iostream>
#include <boost/archive/xml_oarchive.hpp>
#include <boost/thread/thread.hpp>
#include <boost/thread/tss.hpp>

boost::thread_specific_ptr<int> ptr;

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

    return 0;
}
