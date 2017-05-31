#include <lz4.h>

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
  compressed_size = LZ4_compress_default(data, compressed, data_len, 100);
  if (compressed_size <= 0) {
    printf("Error compressing the data\n");
    return 1;
  }

  LZ4_decompress_fast(compressed, decompressed, data_len);
  if (strcmp(data, decompressed) != 0) {
    printf("Error: the compression was not lossless. Original='%s' Result='%s'\n", data, decompressed);
    return 3;
  }

  printf("Successfully compressed and decompressed!\n");
  return 0;
}
