/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 *
 * Based on https://www.gnu.org/software/libidn/libidn2/manual/libidn2.html#Lookup
 */

#include <stdio.h> /* printf, fflush, fgets, stdin, perror, fprintf */
#include <string.h> /* strlen */
#include <locale.h> /* setlocale */
#include <stdlib.h> /* free */
#include <idn2.h> /* idn2_lookup_ul, IDN2_OK, idn2_strerror, idn2_strerror_name */

int
main ()
{
  int rc;
  char src[BUFSIZ];
  char *lookupname;

  setlocale (LC_ALL, "");

  printf ("Enter (possibly non-ASCII) domain name to lookup: ");
  fflush (stdout);
  if (!fgets (src, sizeof (src), stdin))
    {
      perror ("fgets");
      return 1;
    }
  src[strlen (src) - 1] = '\0';

  rc = idn2_lookup_ul (src, &lookupname, 0);
  if (rc != IDN2_OK)
    {
      fprintf (stderr, "error: %s (%s, %d)\n",
           idn2_strerror (rc), idn2_strerror_name (rc), rc);
      return 1;
    }

  printf ("IDNA2008 domain name to lookup in DNS: %s\n", lookupname);

  free (lookupname);

  return 0;
}
