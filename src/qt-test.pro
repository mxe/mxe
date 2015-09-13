# This file is part of MXE.
# See index.html for further information.
TEMPLATE = app
greaterThan(QT_MAJOR_VERSION, 4): TARGET = test-qt5
else: TARGET = test-qt
QT += network sql
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets
HEADERS += qt-test.hpp
SOURCES += qt-test.cpp
FORMS   += qt-test.ui
RESOURCES += qt-test.qrc
