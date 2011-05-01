/* This file is part of mingw-cross-env.       */
/* See doc/index.html for further information. */

#include <iostream>
#include <Poco/DateTimeFormat.h>
#include <Poco/DateTimeFormatter.h>
#include <Poco/LocalDateTime.h>

int main()
{
    std::cout << Poco::DateTimeFormatter::format(Poco::LocalDateTime(), Poco::DateTimeFormat::ISO8601_FORMAT) << std::endl;
    return 0;
}
