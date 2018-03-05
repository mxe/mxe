/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <assert.h>
#include <glib.h>
#include <glib-object.h>
#include <gee.h>

int main (void)
{
    GeeArrayList* list;
    gint i;
    gpointer p;

    list = gee_array_list_new (G_TYPE_INT, NULL, NULL, NULL, NULL, NULL);
    gee_abstract_collection_add ((GeeAbstractCollection*) list, (gpointer) ((gintptr) 1));
    gee_abstract_collection_add ((GeeAbstractCollection*) list, (gpointer) ((gintptr) 2));
    gee_abstract_collection_add ((GeeAbstractCollection*) list, (gpointer) ((gintptr) 5));
    gee_abstract_collection_add ((GeeAbstractCollection*) list, (gpointer) ((gintptr) 4));
    gee_abstract_list_insert ((GeeAbstractList*) list, 2, (gpointer) ((gintptr) 3));
    gee_abstract_list_remove_at ((GeeAbstractList*) list, 3);
    gee_abstract_list_set ((GeeAbstractList*) list, 2, (gpointer) ((gintptr) 10));
    p = gee_abstract_list_get ((GeeAbstractList*) list, 2);
    i = (gint) ((gintptr) p);
    assert (10 == i);
    g_object_unref (list);
    return 0;
}

