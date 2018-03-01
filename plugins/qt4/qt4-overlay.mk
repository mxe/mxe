# This file is part of MXE. See LICENSE.md for licensing information.

# override relevant package variables to build against Qt 4 instead of 5

PKG               := openscenegraph
$(PKG)_DEPS       := $(filter-out qtbase ,$($(PKG)_DEPS)) qt

PKG               := poppler
$(PKG)_DEPS       := $(filter-out qtbase ,$($(PKG)_DEPS)) qt

PKG               := qwt
$(PKG)_DEPS       := cc qt
$(PKG)_QT_DIR     := qt

PKG               := vtk
$(PKG)_DEPS       := cc hdf5 qt libpng expat libxml2 jsoncpp tiff freetype lz4 hdf5 libharu glew
$(PKG)_QT_VERSION := 4
