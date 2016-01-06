/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include "gdal.h"
#include "cpl_conv.h" /* for CPLMalloc() */
int main()
{
  GDALDatasetH  hDataset;
  GDALAllRegister();
  hDataset = GDALOpen( "/tmp/test.img", GA_ReadOnly );
  if( hDataset == NULL )
    {

    }
  else
    {
      GDALClose( hDataset );
    }

  return 0;
}
