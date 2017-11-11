/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <gtk/gtk.h>

static void activate(GtkApplication *app)
{
  GtkWidget *window;
  GtkWidget *box;
  GtkWidget *spinbutton;
  GtkWidget *comboboxtext;

  window = gtk_application_window_new(app);
  box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0);
  spinbutton = gtk_spin_button_new_with_range(0, 10, 1);
  comboboxtext = gtk_combo_box_text_new();
  gtk_combo_box_text_append_text(GTK_COMBO_BOX_TEXT(comboboxtext), "One");
  gtk_combo_box_text_append_text(GTK_COMBO_BOX_TEXT(comboboxtext), "Two");
  gtk_combo_box_text_append_text(GTK_COMBO_BOX_TEXT(comboboxtext), "Three");
  gtk_combo_box_set_active(GTK_COMBO_BOX(comboboxtext), 0);

  gtk_container_add(GTK_CONTAINER(window), box);
  gtk_box_pack_start(GTK_BOX(box), spinbutton, TRUE, TRUE, 0);
  gtk_box_pack_start(GTK_BOX(box), comboboxtext, TRUE, TRUE, 0);

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
