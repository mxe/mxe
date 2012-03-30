/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <stdio.h>
#include <libical/ical.h>

int main(int argc, char *argv[])
{
    icalvalue *v;
    char *str;
    (void)argc;
    (void)argv;

    v = icalvalue_new_caladdress("cap://value/1");
    str = icalvalue_as_ical_string_r(v);
    printf("String: %s\n", str);

    return 0;
}
