/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <QApplication>

#include "qt-test.hpp"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    w.show();
    a.aboutQt();
    return a.exec();
}
