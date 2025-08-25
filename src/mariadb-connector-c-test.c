/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <mariadb/mysql.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    if (mysql_library_init(0, NULL, NULL)) {
        fprintf(stderr, "Could not initialize MariaDB library\n");
        exit(1);
    }

    printf("MariaDB client library initialized: %s\n", mysql_get_client_info());
    mysql_library_end();

    return EXIT_SUCCESS;
}
