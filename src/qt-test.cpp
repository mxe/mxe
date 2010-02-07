/* This file is part of mingw-cross-env.                     */
/* See doc/index.html for further information. */

#include <QtGui/QApplication>
#include "ui_qt-test.h"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    QMainWindow w;
    Ui::MainWindow u;
    u.setupUi(&w);
    w.show();
    return a.exec();
}
