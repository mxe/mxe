/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <json-c/json.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
    json_object *jobj;

    (void)argc;
    (void)argv;

    jobj = json_object_new_object();
    if (!jobj) {
        return 1;
    }
    json_object_object_add(jobj, "key", json_object_new_string("value"));
    printf("%s", json_object_to_json_string(jobj));
    return 0;
}
