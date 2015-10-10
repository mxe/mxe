/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <mysql.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    if (mysql_library_init(0, NULL, NULL)) {
        fprintf(stderr, "Could not initialize MySQL library\n");
        exit(1);
    }

    printf("MySQL client library initialized: %s\n", mysql_get_client_info());
    mysql_library_end();

    return EXIT_SUCCESS;
}
