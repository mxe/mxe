# This file is part of MXE. See LICENSE.md for licensing information.

TEMPLATE = app
TARGET = test-qca-qmake
SOURCES += qca-test.cpp
CONFIG += crypto console
QMAKE_CXXFLAGS += -Wall -Werror

# For static linking:
LIBS += -L$$[QT_INSTALL_PLUGINS]/crypto -lqca-ossl

