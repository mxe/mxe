/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

/*** ugrep.c ***/

/*** https://begriffs.com/posts/2019-05-23-unicode-icu.html ***/

#include <locale.h>
#include <stdlib.h>
#include <string.h>

#include <unicode/ucol.h>
#include <unicode/usearch.h>
#include <unicode/ustdio.h>
#include <unicode/ustring.h>

#define BUFSZ 1024

int main(int argc, char **argv)
{
    char *locale;
    UFILE *in;
    UCollator *col;
    UStringSearch *srch = NULL;
    UErrorCode status = U_ZERO_ERROR;
    UChar *needle, line[BUFSZ];
    UColAttributeValue strength;
    int ignoreInsignificant = 0, asymmetric = 0;
    size_t n;
    long i;

    if (argc != 3)
    {
        fprintf(stderr,
            "Usage: %s {1,2,@,3}[i] pattern\n", argv[0]);
        return EXIT_FAILURE;
    }

    /* cryptic parsing for our cryptic options */
    switch (*argv[1])
    {
        case '1':
            strength = UCOL_PRIMARY;
            break;
        case '2':
            strength = UCOL_SECONDARY;
            break;
        case '@':
            strength = UCOL_SECONDARY, asymmetric = 1;
            break;
        case '3':
            strength = UCOL_TERTIARY;
            break;
        default:
            fprintf(stderr,
                "Unknown strength: %s\n", argv[1]);
            return EXIT_FAILURE;
    }
    /* length of argv[1] is >0 or we would have died */
    ignoreInsignificant = argv[1][strlen(argv[1])-1] == 'i';

    n = strlen(argv[2]) + 1;
    /* if UTF-8 could encode it in n, then UTF-16
     * should be able to as well */
    needle = malloc(n * sizeof(*needle));
    u_strFromUTF8(needle, n, NULL, argv[2], -1, &status);

    /* searching is a degenerate case of collation,
     * so we read the LC_COLLATE locale */
    if (!(locale = setlocale(LC_COLLATE, "")))
    {
        fputs("Cannot determine system collation locale\n",
              stderr);
        return EXIT_FAILURE;
    }

    if (!(in = u_finit(stdin, NULL, NULL)))
    {
        fputs("Error opening stdin as UFILE\n", stderr);
        return EXIT_FAILURE;
    }

    col = ucol_open(locale, &status);
    ucol_setStrength(col, strength);

    if (ignoreInsignificant)
        /* shift ignorable characters down to
         * quaternary level */
        ucol_setAttribute(col, UCOL_ALTERNATE_HANDLING,
                          UCOL_SHIFTED, &status);

    /* Assumes all lines fit in BUFSZ. Should
     * fix this in real code and not increment i */
    for (i = 1; u_fgets(line, BUFSZ, in); ++i)
    {
        /* first time through, set up all options */
        if (!srch)
        {
            srch = usearch_openFromCollator(
                needle, -1, line, -1,
                col, NULL, &status
            );
            if (asymmetric)
                usearch_setAttribute(
                    srch, USEARCH_ELEMENT_COMPARISON,
                    USEARCH_PATTERN_BASE_WEIGHT_IS_WILDCARD,
                    &status
                );
        }
        /* afterward just switch text */
        else
            usearch_setText(srch, line, -1, &status);

        /* check if keyword appears in line */
        if (usearch_first(srch, &status) != USEARCH_DONE)
            u_printf("%ld: %S", i, line);
    }

    usearch_close(srch);
    ucol_close(col);
    u_fclose(in);
    free(needle);

    return EXIT_SUCCESS;
}
