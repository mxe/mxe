/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <sstream>

#include <fcgi_stdio.h>

using std::string;
using std::stringstream;

void show_html(const string &);
bool ends_with(const string &, const string &);
string get_env_var(const string &);

int main(void)
{
    unsigned long counter = 0;
    while (FCGI_Accept() >= 0) {
        ++counter;

        const string full_path = get_env_var("SCRIPT_NAME");
        if (ends_with(full_path, "") || ends_with(full_path, "/")) {
            show_html("<b>Hello, stranger!</b></br>\n"
                      "</br>\n"
                      "What are you looking for?</br>\n"
                      "</br>\n"
                      "Counter of visits may be found <a href='/counter'>here</a></br>\n");
        }
        else if (ends_with(full_path, "/counter") || ends_with(full_path, "/counter/")) {
            stringstream counter_str;
            counter_str << counter;
            show_html("Counter: " + counter_str.str());
        }
        else {
            show_html("<center><h2>This is not the page you are looking for!</h2></center>\n");
        }
    }

    return 0;
}

void show_html(const string &str)
{
    printf("Content-type: text/html\n\n");
    printf("%s", str.c_str());
}

bool ends_with(const string &str, const string &sfx)
{
    if (sfx.size() > str.size())
        return false;

    return equal(str.begin() + str.size() - sfx.size(), str.end(), sfx.begin());
}

string get_env_var(const string &var)
{
    const char *ptr = getenv(var.c_str());
    return (ptr ? string(ptr) : "");
}

