/* This file is part of mingw-cross-env.       */
/* See doc/index.html for further information. */

#include <gtkmm/window.h>
#include <gtkmm/main.h>

int main(int argc, char *argv[])
{
    Gtk::Main g(argc, argv);

    Gtk::Window window;
    window.set_title("Test App mingw-cross-env");
    window.set_default_size(200, 200);
    window.show_all();
    g.run(window);
    return 0;
}
