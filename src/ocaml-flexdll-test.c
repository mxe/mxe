/*
 * This file is part of MXE.
 * See index.html for further information.
 */

/*****************************************************************
   FlexDLL
   Alain Frisch

   Copyright 2007 Institut National de Recherche en Informatique et
   en Automatique.

******************************************************************/

/* An example (main program) */

#include <stdlib.h>
#include <stdio.h>
#include "flexdll.h"

typedef void torun();

void api(char *msg){ printf("API: %s\n", msg); }

int main(int argc, char **argv)
{
  void *sym;
  void *handle;
  int i;
  torun *torun;

  printf("INIT\n"); fflush(stdout);
  flexdll_dump_exports(NULL);
  printf("OK\n"); fflush(stdout);
  for (i = 1; i < argc; i++) {
    printf("** Loading %s\n", argv[i]);
    handle = flexdll_dlopen(argv[i], FLEXDLL_RTLD_GLOBAL);
    if (NULL == handle) { printf("error: %s\n", flexdll_dlerror()); exit(2); }
    printf("** handle = %p\n", handle);
    flexdll_dump_exports(handle);
    flexdll_dump_relocations(handle);

    if (NULL == handle) { printf("error: %s\n", flexdll_dlerror()); exit(2); }

    torun = flexdll_dlsym(handle, "torun");
    if (torun) torun();
  }
  exit(0);
}
