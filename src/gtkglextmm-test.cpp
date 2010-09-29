/* This file is part of mingw-cross-env.       */
/* See doc/index.html for further information. */

#include <gtkmm/main.h>
#include <gtkmm/gl/init.h>

int main(int argc, char *argv[])
{
    Gtk::Main g(argc, argv);
    Gtk::GL::init(argc, argv);
    g.run();
    return 0;
}
