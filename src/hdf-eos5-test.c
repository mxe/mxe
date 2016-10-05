/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include "HE5_HdfEosDef.h"

int main() {

  char filename[] = "test.he5";
  hid_t output_file = HE5_SWopen(filename, H5F_ACC_TRUNC);
  char swathname[] = "testswath";
  hid_t swath_id = HE5_SWcreate(output_file, swathname);

  char dimension[] = "dummydim";
  HE5_SWdefdim(swath_id, dimension, 10);
  char fieldname[] = "test_field";
  HE5_SWdefdatafield(swath_id, fieldname, dimension, NULL, HE5T_NATIVE_FLOAT, 0);

  hssize_t start[HE5_DTSETRANKMAX] = {0};
  hsize_t edge[HE5_DTSETRANKMAX] = {10};
  float testdata[10];

  for(unsigned int i=0; i<10; ++i)
    testdata[i] = (float)i;

  HE5_SWwritefield(swath_id, fieldname, start, NULL, edge, testdata);

  HE5_SWdetach(swath_id);
  HE5_SWclose(output_file);

  return 0;
}
