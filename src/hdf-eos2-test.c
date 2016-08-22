/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <hdf.h>
#include <HdfEosDef.h>
#include <mfhdf.h>

#include <stdio.h>

int main() {
  char filename[] = "test.he4";
  int fid = SWopen(filename, DFACC_CREATE);
  char swathname[] = "myswath";
  int swid = SWcreate(fid, swathname);

  char dimname[] = "mydim";
  const int32 dimlen = 10;
  int rc = SWdefdim(swid, dimname, dimlen);
  printf("SWdefdim: %d\n", rc);
  char fieldname[] = "test_field";
  rc = SWdefdatafield(swid, fieldname, dimname, DFNT_FLOAT, 0);
  printf("SWdefdatafield: %d\n", rc);

  int32 start = 0;
  int32 edge = dimlen;
  float data[dimlen];
  for (int i=0; i<dimlen; ++i) {
    data[i] = 1.0 + i;
  }
  rc = SWwritefield(swid, fieldname, &start, NULL, &edge, data);
  printf("SWwritefield: %d\n", rc);

  rc = SWdetach(swid);
  printf("SWdetach: %d\n", rc);
  rc = SWclose(fid);
  printf("SWclose: %d\n", rc);
}
