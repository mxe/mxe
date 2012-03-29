/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <gtk/gtk.h>

int main(int argc, char *argv[])
{
    GtkWidget* window;
    GtkWidget* button;

    gtk_init(&argc, &argv);

    window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    button = gtk_button_new_with_label("Hello World");
    gtk_container_add(GTK_CONTAINER(window), button);

    g_signal_connect_swapped(
        G_OBJECT(button), "clicked",
        G_CALLBACK(gtk_widget_destroy), G_OBJECT(window));

    g_signal_connect(
        G_OBJECT(window), "destroy",
        G_CALLBACK(gtk_main_quit), NULL);

    gtk_widget_show(button);
    gtk_widget_show(window);
    gtk_main();
    return 0;
}
