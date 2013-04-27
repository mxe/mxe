/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <gtkimageview/gtkimageview.h>

int main (int argc, char *argv[])
{
    gtk_init (&argc, &argv);
    GtkWidget *window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
    GtkWidget *view = gtk_image_view_new ();
    GdkPixbuf *pixbuf = gdk_pixbuf_new_from_file ("tests/gnome_logo.jpg", NULL);

    gtk_image_view_set_pixbuf (GTK_IMAGE_VIEW (view), pixbuf, TRUE);
    gtk_container_add (GTK_CONTAINER (window), view);
    gtk_widget_show_all (window);
    gtk_main ();
    return 0;
}
