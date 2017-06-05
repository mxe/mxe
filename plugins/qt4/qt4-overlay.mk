# This file is part of MXE. See LICENSE.md for licensing information.

# override relevant vtk and qwt variables to build against Qt 4 instead of 5

PKG               := vtk
$(PKG)_DEPS       := gcc hdf5 qt libpng expat libxml2 jsoncpp tiff freetype lz4 hdf5 libharu glew
$(PKG)_QT_VERSION := 4

PKG               := qwt
$(PKG)_DEPS       := gcc qt
$(PKG)_QT_DIR     := qt
