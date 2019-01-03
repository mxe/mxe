/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <zstd.h>

#include <string.h>
#include <stdio.h>

int
main(int argc, char *argv[])
{
  const char *data;
  int data_len;
  char compressed[100];
  int compressed_size;
  char decompressed[100];

  (void)argc;
  (void)argv;

  data = "Some data to compress";
  data_len = strlen(data);

  /* compress */
  compressed_size  = ZSTD_compress(compressed, sizeof(compressed), data, data_len, 1);
  if (compressed_size <= 0) {
    printf("Error compressing the data\n");
    return 1;
  }

  ZSTD_decompress(decompressed, data_len, compressed, compressed_size);
  if (strcmp(data, decompressed) != 0) {
    printf("Error: the compression was not lossless. Original='%s' Result='%s'\n", data, decompressed);
    return 3;
  }

  printf("Successfully compressed and decompressed!\n");
  return 0;
}
