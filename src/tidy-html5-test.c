// This file is part of MXE. See LICENSE.md for licensing information.

#include <tidy.h>
#include <tidybuffio.h>

#include <stdbool.h>
#include <stdio.h>


int main()
{
    const char *input = "<h1>Blah</h1><p><b>Blah-blah-blah!</b>";
    printf("Input (HTML fragment):\n%s\n\n", input);
    fflush(stdout);

    TidyDoc tDoc = tidyCreate();
    TidyBuffer output = {0};
    TidyBuffer errBuf = {0};
    int rc = -1;

    const bool ok = tidyOptSetBool(tDoc, TidyXhtmlOut, yes);

    if (ok)
        rc = tidySetErrorBuffer(tDoc, &errBuf);
    if (rc >= 0)
        rc = tidyParseString(tDoc, input);
    if (rc >= 0)
        rc = tidyCleanAndRepair(tDoc);
    if (rc >= 0)
        rc = tidyRunDiagnostics(tDoc);
    if (rc > 1)
        rc = (tidyOptSetBool(tDoc, TidyForceOutput, yes) ? rc : -1);
    if (rc >= 0)
        rc = tidySaveBuffer(tDoc, &output);

    if (rc > 0)
        printf("Diagnostics:\n%s\n\n", errBuf.bp);
    if (rc >= 0)
        printf("Output (valid HTML document):\n%s\n\n", output.bp);
    else
        printf("Unknown error: %d.\n\n", rc);
    fflush(stdout);

    tidyBufFree(&errBuf);
    tidyBufFree(&output);
    tidyRelease(tDoc);

    return rc;
}
