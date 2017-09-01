/* 

demo4.c

Author: Sandro Furieri a.furieri@lqt.it

This software is provided 'as-is', without any express or implied
warranty.  In no event will the author be held liable for any
damages arising from the use of this software.

Permission is granted to anyone to use this software for any
purpose, including commercial applications, and to alter it and
redistribute it freely

*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

/*
these headers are required in order to support
SQLite/SpatiaLite */
#include <sqlite3.h>
#include <spatialite/gaiageo.h>
#include <spatialite.h>

int
main (int argc, char *argv[])
{
    int ret;
    sqlite3 *handle;
    sqlite3_stmt *stmt;
    char sql[256];
    char *err_msg = NULL;
    double x;
    double y;
    int pk;
    int ix;
    int iy;
    gaiaGeomCollPtr geo = NULL;
    unsigned char *blob;
    int blob_size;
    int i;
    char **results;
    int n_rows;
    int n_columns;
    char *count;
    clock_t t0;
    clock_t t1;
    void *cache;


    if (argc != 2)
      {
	  fprintf (stderr, "usage: %s test_db_path\n", argv[0]);
	  return -1;
      }


/* 
trying to connect the test DB: 
- this demo is intended to create a new, empty database
*/
    ret = sqlite3_open_v2 (argv[1], &handle,
			   SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (ret != SQLITE_OK)
      {
	  printf ("cannot open '%s': %s\n", argv[1], sqlite3_errmsg (handle));
	  sqlite3_close (handle);
	  return -1;
      }
    cache = spatialite_alloc_connection ();
    spatialite_init_ex (handle, cache, 0);


/* showing the SQLite version */
    printf ("SQLite version: %s\n", sqlite3_libversion ());
/* showing the SpatiaLite version */
    printf ("SpatiaLite version: %s\n", spatialite_version ());
    printf ("\n\n");


/* 
we are supposing this one is an empty database,
so we have to create the Spatial Metadata
*/
    strcpy (sql, "SELECT InitSpatialMetadata(1)");
    ret = sqlite3_exec (handle, sql, NULL, NULL, &err_msg);
    if (ret != SQLITE_OK)
      {
/* some error occurred */
	  printf ("InitSpatialMetadata() error: %s\n", err_msg);
	  sqlite3_free (err_msg);
	  goto abort;
      }


/*
now we can create the test table
for simplicity we'll define only one column, the primary key
*/
    strcpy (sql, "CREATE TABLE test (");
    strcat (sql, "PK INTEGER NOT NULL PRIMARY KEY)");
    ret = sqlite3_exec (handle, sql, NULL, NULL, &err_msg);
    if (ret != SQLITE_OK)
      {
/* an error occurred */
	  printf ("CREATE TABLE 'test' error: %s\n", err_msg);
	  sqlite3_free (err_msg);
	  goto abort;
      }


/*
... we'll add a Geometry column of POINT type to the test table 
*/
    strcpy (sql, "SELECT AddGeometryColumn('test', 'geom', 3003, 'POINT', 2)");
    ret = sqlite3_exec (handle, sql, NULL, NULL, &err_msg);
    if (ret != SQLITE_OK)
      {
/* an error occurred */
	  printf ("AddGeometryColumn() error: %s\n", err_msg);
	  sqlite3_free (err_msg);
	  goto abort;
      }


/*
and finally we'll enable this geo-column to have a Spatial Index based on MBR caching
*/
    strcpy (sql, "SELECT CreateMbrCache('test', 'geom')");
    ret = sqlite3_exec (handle, sql, NULL, NULL, &err_msg);
    if (ret != SQLITE_OK)
      {
/* an error occurred */
	  printf ("CreateMbrCache() error: %s\n", err_msg);
	  sqlite3_free (err_msg);
	  goto abort;
      }

    printf
	("\nnow we are going to insert 1 million POINTs; wait, please ...\n\n");

    t0 = clock ();
/*
beginning a transaction

*** this step is absolutely critical ***

the SQLite engine is a TRANSACTIONAL one
the whole batch of INSERTs has to be performed as an unique transaction,
otherwise performance will be surely very poor
*/
    strcpy (sql, "BEGIN");
    ret = sqlite3_exec (handle, sql, NULL, NULL, &err_msg);
    if (ret != SQLITE_OK)
      {
/* an error occurred */
	  printf ("BEGIN error: %s\n", err_msg);
	  sqlite3_free (err_msg);
	  goto abort;
      }



/* 
preparing to populate the test table
we'll use a Prepared Statement we can reuse in order to insert each row
*/
    strcpy (sql, "INSERT INTO test (pk, geom) VALUES (?, ?)");
    ret = sqlite3_prepare_v2 (handle, sql, strlen (sql), &stmt, NULL);
    if (ret != SQLITE_OK)
      {
/* an error occurred */
	  printf ("INSERT SQL error: %s\n", sqlite3_errmsg (handle));
	  goto abort;
      }

    pk = 0;
    for (ix = 0; ix < 1000; ix++)
      {
	  x = 1000000.0 + (ix * 10.0);
	  for (iy = 0; iy < 1000; iy++)
	    {
/* this double loop will insert 1 million rows into the the test table */

		y = 4000000.0 + (iy * 10.0);
		pk++;
		if ((pk % 25000) == 0)
		  {
		      t1 = clock ();
		      printf ("insert row: %d\t\t[elapsed time: %1.3f]\n",
			      pk, (double) (t1 - t0) / CLOCKS_PER_SEC);
		  }

/* preparing the geometry to insert */
		geo = gaiaAllocGeomColl ();
		geo->Srid = 3003;
		gaiaAddPointToGeomColl (geo, x, y);

/* transforming this geometry into the SpatiaLite BLOB format */
		gaiaToSpatiaLiteBlobWkb (geo, &blob, &blob_size);

/* we can now destroy the geometry object */
		gaiaFreeGeomColl (geo);

/* resetting Prepared Statement and bindings */
		sqlite3_reset (stmt);
		sqlite3_clear_bindings (stmt);

/* binding parameters to Prepared Statement */
		sqlite3_bind_int64 (stmt, 1, pk);
		sqlite3_bind_blob (stmt, 2, blob, blob_size, free);

/* performing actual row insert */
		ret = sqlite3_step (stmt);
		if (ret == SQLITE_DONE || ret == SQLITE_ROW)
		    ;
		else
		  {
/* an unexpected error occurred */
		      printf ("sqlite3_step() error: %s\n",
			      sqlite3_errmsg (handle));
		      sqlite3_finalize (stmt);
		      goto abort;
		  }

	    }
      }
/* we have now to finalize the query [memory cleanup] */
    sqlite3_finalize (stmt);



/*
committing the transaction

*** this step is absolutely critical ***

if we don't confirm the still pending transaction,
any update will be lost
*/
    strcpy (sql, "COMMIT");
    ret = sqlite3_exec (handle, sql, NULL, NULL, &err_msg);
    if (ret != SQLITE_OK)
      {
/* an error occurred */
	  printf ("COMMIT error: %s\n", err_msg);
	  sqlite3_free (err_msg);
	  goto abort;
      }



/*
now we'll optimize the table
*/
    strcpy (sql, "ANALYZE test");
    ret = sqlite3_exec (handle, sql, NULL, NULL, &err_msg);
    if (ret != SQLITE_OK)
      {
/* an error occurred */
	  printf ("ANALYZE error: %s\n", err_msg);
	  sqlite3_free (err_msg);
	  goto abort;
      }


    for (ix = 0; ix < 3; ix++)
      {
	  printf ("\nperforming test#%d - not using Spatial Index\n", ix);
/* 
now we'll perform the spatial query WITHOUT using the Spatial Index
we'll loop 3 times in order to avoid buffering-caching side effects
*/
	  strcpy (sql, "SELECT Count(*) FROM test ");
	  strcat (sql, "WHERE MbrWithin(geom, BuildMbr(");
	  strcat (sql, "1000400.5, 4000400.5, ");
	  strcat (sql, "1000450.5, 4000450.5))");
	  t0 = clock ();
	  ret = sqlite3_get_table (handle, sql, &results, &n_rows, &n_columns,
				   &err_msg);
	  if (ret != SQLITE_OK)
	    {
/* an error occurred */
		printf ("NoSpatialIndex SQL error: %s\n", err_msg);
		sqlite3_free (err_msg);
		goto abort;
	    }
	  count = (char*) "";
	  for (i = 1; i <= n_rows; i++)
	    {
		count = results[(i * n_columns) + 0];
	    }
	  t1 = clock ();
	  printf ("Count(*) = %d\t\t[elapsed time: %1.4f]\n", atoi (count),
		  (double) (t1 - t0) / CLOCKS_PER_SEC);
/* we can now free the table results */
	  sqlite3_free_table (results);
      }


    for (ix = 0; ix < 3; ix++)
      {
	  printf ("\nperforming test#%d - using the MBR cache Spatial Index\n",
		  ix);
/* 
now we'll perform the spatial query USING the MBR cache Spatial Index
we'll loop 3 times in order to avoid buffering-caching side effects
*/
	  strcpy (sql, "SELECT Count(*) FROM test ");
	  strcat (sql, "WHERE ROWID IN (");
	  strcat (sql, "SELECT rowid FROM cache_test_geom WHERE ");
	  strcat (sql,
		  "mbr = FilterMbrWithin(1000400.5, 4000400.5, 1000450.5, 4000450.5))");

/*
YES, this query is a very unhappy one
the idea is simply to simulate exactly the same conditions as above
*/
	  t0 = clock ();
	  ret = sqlite3_get_table (handle, sql, &results, &n_rows, &n_columns,
				   &err_msg);
	  if (ret != SQLITE_OK)
	    {
/* an error occurred */
		printf ("SpatialIndex SQL error: %s\n", err_msg);
		sqlite3_free (err_msg);
		goto abort;
	    }
	  count = (char*) "";
	  for (i = 1; i <= n_rows; i++)
	    {
		count = results[(i * n_columns) + 0];
	    }
	  t1 = clock ();
	  printf ("Count(*) = %d\t\t[elapsed time: %1.4f]\n", atoi (count),
		  (double) (t1 - t0) / CLOCKS_PER_SEC);
/* we can now free the table results */
	  sqlite3_free_table (results);
      }


/* disconnecting the test DB */
    ret = sqlite3_close (handle);
    if (ret != SQLITE_OK)
      {
	  printf ("close() error: %s\n", sqlite3_errmsg (handle));
	  return -1;
      }
    printf ("\n\nsample successfully terminated\n");
    spatialite_cleanup_ex (cache);
    return 0;

  abort:
    sqlite3_close (handle);
    spatialite_cleanup_ex (cache);
    spatialite_shutdown();
    return -1;
}
