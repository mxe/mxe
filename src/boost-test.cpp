/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <iostream>
#include <tuple>

#include <boost/archive/xml_oarchive.hpp>
#include <boost/thread/thread.hpp>
#include <boost/thread/tss.hpp>

boost::thread_specific_ptr<int> ptr;

// https://www.boost.org/doc/libs/1_60_0/libs/context/doc/html/context/context.html
#include <boost/context/all.hpp>

void test_thread()
{
	if (ptr.get() == 0) {
		ptr.reset(new int(0));
	}
	std::cout << "Hello, World! from thread" << std::endl;
}

int main(int, char * [])
{
	{
		boost::archive::xml_oarchive oa(std::cout);
		std::string s = "\n\n    Hello, World!\n\n";
		oa << BOOST_SERIALIZATION_NVP(s);
	}

	{
		boost::thread thrd(test_thread);
		thrd.join();
	}

	{
		namespace ctx = boost::context;
		int data = 0;
		ctx::continuation c = ctx::callcc([&data](ctx::continuation && c) {
			std::cout << "f1: entered first time: " << data << std::endl;
			data += 1;
			c = c.resume();
			std::cout << "f1: entered second time: " << data << std::endl;
			data += 1;
			c = c.resume();
			std::cout << "f1: entered third time: " << data << std::endl;
			return std::move(c);
		});
		std::cout << "f1: returned first time: " << data << std::endl;
		data += 1;
		c = c.resume();
		std::cout << "f1: returned second time: " << data << std::endl;
		data += 1;
		c = c.resume_with([&data](ctx::continuation && c) {
			std::cout << "f2: entered: " << data << std::endl;
			data = -1;
			return std::move(c);
		});
		std::cout << "f1: returned third time" << std::endl;
	}

	return 0;
}
