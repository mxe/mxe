/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <stdlib.h>
#include <string.h>
#include <hdf5.h>
#if H5_VERS_MINOR > 6
  #include <hdf5_hl.h>
#else
  #include <H5TA.h>
#endif

/*
#include <cmath>
*/
#include <sstream>
/*
#include <iostream>
*/

const static unsigned int DATELEN = 128;
const static unsigned int TIMELEN = 128;
const static unsigned int UNITLEN = 16;


int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

typedef struct rt {
    int channels;
    char date[DATELEN];
    char time[TIMELEN];
} rt;

//    H5Fis_hdf5("/dev/null");

/*
* Create a new file using H5ACC_TRUNC access,
* default file creation properties, and default file
* access properties.
* Then close the file.
*/

    const int NRECORDS = 1;
    const int NFIELDS = 3;
    char fName[] = "tmp.h5";

    /* Calculate the size and the offsets of our struct members in memory */
    size_t rt_offset[NFIELDS] = {  HOFFSET( rt, channels ),
                                   HOFFSET( rt, date ),
                                   HOFFSET( rt, time )};

    rt p_data;
    p_data.channels = 1;
    strcpy( p_data.date, "1234-Dec-31");
    strcpy( p_data.time, "12:34:56");


    hid_t file_id = H5Fcreate(fName, H5F_ACC_TRUNC, H5P_DEFAULT, H5P_DEFAULT);


    /* Define field information */
    const char *field_names[NFIELDS]  =  { "channels", "date", "time" };
    hid_t      field_type[NFIELDS];

    /* Initialize the field field_type */
    hid_t string_type1 = H5Tcopy( H5T_C_S1 );
    hid_t string_type2 = H5Tcopy( H5T_C_S1 );
    H5Tset_size( string_type1,  strlen(p_data.date));
    H5Tset_size( string_type2,  strlen(p_data.time));
    field_type[0] = H5T_NATIVE_INT;
    field_type[1] = string_type1;
    field_type[2] = string_type2;

    std::ostringstream desc;
    desc << "Description of " << fName;

    herr_t status = H5TBmake_table( desc.str().c_str(), file_id, "description", (hsize_t)NFIELDS, (hsize_t)NRECORDS, sizeof(rt),
                                    field_names, rt_offset, field_type, 10, NULL, 0, &p_data  );

    if (status < 0) {
        perror("Exception while writing description in stfio::exportHDF5File");
        H5Fclose(file_id);
        H5close();
        exit(-1);
    }

    H5Fclose(file_id);

    return(0);
}

