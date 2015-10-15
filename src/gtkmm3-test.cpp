/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <gtkmm/application.h>
#include <gtkmm/button.h>
#include <gtkmm/window.h>

int main(int argc, char *argv[])
{
  Glib::RefPtr<Gtk::Application> app = Gtk::Application::create(argc, argv);

  Gtk::Window window;
  Gtk::Button button("Hello World");
  button.signal_clicked().connect(sigc::mem_fun(window, &Gtk::Window::close));
  window.add(button);
  window.show_all();

  return app->run(window);
}
