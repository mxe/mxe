/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <cstdlib>
#include "log4cxx/logger.h"
#include "log4cxx/basicconfigurator.h"
#include "log4cxx/helpers/exception.h"

using namespace log4cxx;
using namespace log4cxx::helpers;

LoggerPtr logger(Logger::getLogger("MXE"));

int main(int argc, char **argv)
{
    (void)argc;
    (void)argv;

    int result = EXIT_SUCCESS;
    try
    {
        BasicConfigurator::configure();
        LOG4CXX_INFO(logger, "Hello World!");
    }
    catch(Exception&)
    {
        result = EXIT_FAILURE;
    }

    return result;
}
