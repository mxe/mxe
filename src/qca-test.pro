# This file is part of MXE. See LICENSE.md for licensing information.

TEMPLATE = app
greaterThan(QT_MAJOR_VERSION, 4): TARGET = test-qca5-qmake
else: TARGET = test-qca-qmake
SOURCES += qca-test.cpp
CONFIG += crypto console
QMAKE_CXXFLAGS += -Wall -Werror

# For static linking:
# QTPLUGIN += qca-gnupg qca-logger qca-ossl qca-softstore qca-qt5
# LIBS += -L$$[QT_INSTALL_PLUGINS]/crypto

