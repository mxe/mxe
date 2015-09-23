/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <gtk/gtk.h>

static void activate(GtkApplication *app)
{
  GtkWidget *window;
  GtkWidget *button;

  window = gtk_application_window_new(app);
  button = gtk_button_new_with_label("Hello World");

  g_signal_connect_swapped(button, "clicked",
			   G_CALLBACK(gtk_widget_destroy), window);
  gtk_container_add(GTK_CONTAINER(window), button);

  gtk_widget_show_all(window);
}

int main(int argc, char *argv[])
{
  GtkApplication *app;
  int status;

  app = gtk_application_new(NULL, G_APPLICATION_FLAGS_NONE);
  g_signal_connect(app, "activate", G_CALLBACK(activate), NULL);
  status = g_application_run(G_APPLICATION(app), argc, argv);
  g_object_unref(app);

  return status;
}
