/* This file is part of mingw-cross-env.       */
/* See doc/index.html for further information. */

#include <iostream>
#include <boost/archive/xml_oarchive.hpp>

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    boost::archive::xml_oarchive oa(std::cout);
    std::string s = "\n\n    Hello, World!\n\n";
    oa << BOOST_SERIALIZATION_NVP(s);

    return 0;
}
