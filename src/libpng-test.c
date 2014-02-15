/*
 * This file is part of MXE.
 * See index.html for further information.
 *
 * This is a slightly modified version of:
 * http://ironalbatross.net/wiki/index.php5?title=CPP_LIBPNG#Minimal_Example_of_writing_a_PNG_File
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <png.h>

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    /* PNG structs and types */
    png_byte color_type;
    png_byte bit_depth;
    png_structp png_ptr;
    png_infop info_ptr;
    png_bytep *row_pointers;

    int height, width;
    FILE *fp;

    width = 640;
    height = 480;

    color_type = PNG_COLOR_TYPE_RGB;
    bit_depth = 8; /* Number of bits per color, not per pixel */

    /* Dynamic 2D array in C */
    row_pointers = (png_bytep *)malloc( sizeof(png_bytep) * height);
    int i;
    for(i = 0; i < height; i++)
    {
        int j;
        row_pointers[i] = malloc(sizeof(png_byte) * width * 3);
        for(j = 0; j < width; j++)
        {
            row_pointers[i][0+3*j] = i % 255;   /* R */
            row_pointers[i][1+3*j] = j % 255;   /* G */
            row_pointers[i][2+3*j] = (i * j) % 255; /* B */
        }
    }

    /* Write the data out to the PNG file */
    fp = fopen("test.png","wb");
    png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING,NULL,NULL,NULL);
    info_ptr = png_create_info_struct(png_ptr);
    png_init_io(png_ptr,fp);
    png_set_IHDR(png_ptr, info_ptr, width, height,
                 bit_depth, color_type, PNG_INTERLACE_NONE,
                 PNG_COMPRESSION_TYPE_BASE, PNG_FILTER_TYPE_BASE);
    png_write_info(png_ptr, info_ptr);
    png_write_image(png_ptr, row_pointers);
    png_write_end(png_ptr, NULL);

    /* Free up memory after use */
    for(i = 0; i < height; i++)
    {
        free(row_pointers[i]);
    }
    free(row_pointers);

    return 0;
}
