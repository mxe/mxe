/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

/*
 * Modifications from the original example:
 * - Do not use negative reserved return codes in main()
 * - Sort headers and use <> instead of "" for lensfun.h
 */

/*
    https://lensfun.sourceforge.io/manual/v0.3.2/example_8c-example.html
    A simple example of library usage from plain C
*/

#include <stdio.h>
#include <locale.h>

#include <glib.h>
#include <lensfun.h>

int main ()
{    int i, j;
    const struct lfMount *const *mounts;
    const struct lfCamera *const *cameras;
    const struct lfLens *const *lenses;
    struct lfDatabase *ldb;
    lfError e;

    /* Initialize locale in order to get translated names */
    setlocale (LC_ALL, "");

    ldb = lf_db_new ();
    if (!ldb)
    {
        fprintf (stderr, "Failed to create database\n");
        return 1;
    }

    g_print ("HomeDataDir: %s\n", ldb->HomeDataDir);

    lf_db_load (ldb);

    g_print ("< --------------- < Mounts > --------------- >\n");
    mounts = lf_db_get_mounts (ldb);
    for (i = 0; mounts [i]; i++)
    {
        g_print ("Mount: %s\n", lf_mlstr_get (mounts [i]->Name));
        if (mounts [i]->Compat)
            for (j = 0; mounts [i]->Compat [j]; j++)
                g_print ("\tCompat: %s\n", mounts [i]->Compat [j]);
    }

    g_print ("< --------------- < Cameras > --------------- >\n");
    cameras = lf_db_get_cameras (ldb);
    for (i = 0; cameras [i]; i++)
    {
        g_print ("Camera: %s / %s %s%s%s\n",
            lf_mlstr_get (cameras [i]->Maker),
            lf_mlstr_get (cameras [i]->Model),
            cameras [i]->Variant ? "(" : "",
            cameras [i]->Variant ? lf_mlstr_get (cameras [i]->Variant) : "",
            cameras [i]->Variant ? ")" : "");
        g_print ("\tMount: %s\n", lf_db_mount_name (ldb, cameras [i]->Mount));
        g_print ("\tCrop factor: %g\n", cameras [i]->CropFactor);
    }

    g_print ("< --------------- < Lenses > --------------- >\n");
    lenses = lf_db_get_lenses (ldb);
    for (i = 0; lenses [i]; i++)
    {
        g_print ("Lens: %s / %s\n",
            lf_mlstr_get (lenses [i]->Maker),
            lf_mlstr_get (lenses [i]->Model));
        g_print ("\tCrop factor: %g\n", lenses [i]->CropFactor);
        g_print ("\tAspect ratio: %g\n", lenses [i]->AspectRatio);
        g_print ("\tFocal: %g-%g\n", lenses [i]->MinFocal, lenses [i]->MaxFocal);
        g_print ("\tAperture: %g-%g\n", lenses [i]->MinAperture, lenses [i]->MaxAperture);
        g_print ("\tCenter: %g,%g\n", lenses [i]->CenterX, lenses [i]->CenterY);
        if (lenses [i]->Mounts)
            for (j = 0; lenses [i]->Mounts [j]; j++)
                g_print ("\tMount: %s\n", lf_db_mount_name (ldb, lenses [i]->Mounts [j]));
    }

    g_print ("< ---< Saving database into one big file >--- >\n");
    e = lf_db_save_file (ldb, "example-big.xml", mounts, cameras, lenses);
    if (e != LF_NO_ERROR)
        fprintf (stderr, "Failed writing to file, error code %d\n", e);

    lf_db_destroy (ldb);
    return 0;
}
