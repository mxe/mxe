/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <gtkmm/window.h>
#include <gtkmm/main.h>

int main(int argc, char *argv[])
{
    Gtk::Main g(argc, argv);

    Gtk::Window window;
    window.set_title("Test App MXE");
    window.set_default_size(200, 200);
    window.show_all();
    g.run(window);
    return 0;
}
