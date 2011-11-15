/* This file is part of mingw-cross-env.       */
/* See doc/index.html for further information. */

#include <QApplication>
#include <QtPlugin>
#include "ui_qt-test.h"

#ifdef  Q_OS_AIX
#error "Q_OS_AIX is defined"
#endif

#ifdef  Q_OS_BSD4
#error "Q_OS_BSD4 is defined"
#endif

#ifdef  Q_OS_BSDI
#error "Q_OS_BSDI is defined"
#endif

#ifdef  Q_OS_CYGWIN
#error "Q_OS_CYGWIN is defined"
#endif

#ifdef  Q_OS_DARWIN
#error "Q_OS_DARWIN is defined"
#endif

#ifdef  Q_OS_DGUX
#error "Q_OS_DGUX is defined"
#endif

#ifdef  Q_OS_DYNIX
#error "Q_OS_DYNIX is defined"
#endif

#ifdef  Q_OS_FREEBSD
#error "Q_OS_FREEBSD is defined"
#endif

#ifdef  Q_OS_HPUX
#error "Q_OS_HPUX is defined"
#endif

#ifdef  Q_OS_HURD
#error "Q_OS_HURD is defined"
#endif

#ifdef  Q_OS_IRIX
#error "Q_OS_IRIX is defined"
#endif

#ifdef  Q_OS_LINUX
#error "Q_OS_LINUX is defined"
#endif

#ifdef  Q_OS_LYNX
#error "Q_OS_LYNX is defined"
#endif

#ifdef  Q_OS_MAC
#error "Q_OS_MAC is defined"
#endif

#ifdef  Q_OS_MSDOS
#error "Q_OS_MSDOS is defined"
#endif

#ifdef  Q_OS_NETBSD
#error "Q_OS_NETBSD is defined"
#endif

#ifdef  Q_OS_OS2
#error "Q_OS_OS2 is defined"
#endif

#ifdef  Q_OS_OPENBSD
#error "Q_OS_OPENBSD is defined"
#endif

#ifdef  Q_OS_OS2EMX
#error "Q_OS_OS2EMX is defined"
#endif

#ifdef  Q_OS_OSF
#error "Q_OS_OSF is defined"
#endif

#ifdef  Q_OS_QNX
#error "Q_OS_QNX is defined"
#endif

#ifdef  Q_OS_RELIANT
#error "Q_OS_RELIANT is defined"
#endif

#ifdef  Q_OS_SCO
#error "Q_OS_SCO is defined"
#endif

#ifdef  Q_OS_SOLARIS
#error "Q_OS_SOLARIS is defined"
#endif

#ifdef  Q_OS_SYMBIAN
#error "Q_OS_SYMBIAN is defined"
#endif

#ifdef  Q_OS_ULTRIX
#error "Q_OS_ULTRIX is defined"
#endif

#ifdef  Q_OS_UNIX
#error "Q_OS_UNIX is defined"
#endif

#ifdef  Q_OS_UNIXWARE
#error "Q_OS_UNIXWARE is defined"
#endif

#ifndef Q_OS_WIN32
#error "Q_OS_WIN32 is not defined"
#endif

#ifdef  Q_OS_WINCE
#error "Q_OS_WINCE is defined"
#endif

#ifdef  Q_WS_S60
#error "Q_WS_S60 is defined"
#endif

#ifdef  Q_WS_X11
#error "Q_WS_X11 is defined"
#endif

#ifdef  Q_WS_MAC
#error "Q_WS_MAC is defined"
#endif

#ifdef  Q_WS_OWS
#error "Q_WS_QWS is defined"
#endif

#ifndef Q_WS_WIN
#error "Q_WS_WIN is not defined"
#endif

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    QMainWindow w;
    Ui::MainWindow u;
    u.setupUi(&w);
    w.show();
    return a.exec();
}
