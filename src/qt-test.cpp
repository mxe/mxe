/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <QApplication>

// qmake automatically includes static plugin support
#ifdef QT_STATICPLUGIN
#include <QtPlugin>
#if QT_VERSION >= 0x050000
Q_IMPORT_PLUGIN(QWindowsIntegrationPlugin)
Q_IMPORT_PLUGIN(QICOPlugin)
#else
Q_IMPORT_PLUGIN(qsvg)
#endif
#endif

#include "qt-test.hpp"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    w.show();
    a.aboutQt();
    return a.exec();
}
