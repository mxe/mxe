/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

/*
 * Copyright (c) 2013 Andrew Kelley
 *
 * This file is part of liblaxjson, which is MIT licensed.
 * See https://opensource.org/licenses/MIT
 */

#include <laxjson.h>
#include <stdio.h>

static int on_string(struct LaxJsonContext *context,
    enum LaxJsonType type, const char *value, int length)
{
    (void)context;
    (void)length;
    char *type_name = (type == LaxJsonTypeProperty) ? "property" : "string";
    printf("%s: %s\n", type_name, value);
    return 0;
}

static int on_number(struct LaxJsonContext *context, double x)
{
    (void)context;
    printf("number: %f\n", x);
    return 0;
}

static int on_primitive(struct LaxJsonContext *context, enum LaxJsonType type)
{
    (void)context;
    char *type_name;
    if (type == LaxJsonTypeTrue)
        type_name = "true";
    else if (type == LaxJsonTypeFalse)
        type_name = "false";
    else
        type_name = "null";

    printf("primitive: %s\n", type_name);
    return 0;
}

static int on_begin(struct LaxJsonContext *context, enum LaxJsonType type)
{
    (void)context;
    char *type_name = (type == LaxJsonTypeArray) ? "array" : "object";
    printf("begin %s\n", type_name);
    return 0;
}

static int on_end(struct LaxJsonContext *context, enum LaxJsonType type)
{
    (void)context;
    char *type_name = (type == LaxJsonTypeArray) ? "array" : "object";
    printf("end %s\n", type_name);
    return 0;
}

int main() {
    char buf[1024];
    struct LaxJsonContext *context;
    FILE *f;
    int amt_read;

    context = lax_json_create();

    context->userdata = NULL; /* can set this to whatever you want */
    context->string = on_string;
    context->number = on_number;
    context->primitive = on_primitive;
    context->begin = on_begin;
    context->end = on_end;

    f = fopen("file.json", "rb");
    while ((amt_read = fread(buf, 1, sizeof(buf), f))) {
        lax_json_feed(context, amt_read, buf);
    }
    lax_json_destroy(context);

    return 0;
}

