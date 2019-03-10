# This file is part of MXE. See LICENSE.md for licensing information.

# override relevant package variables to build against Qt 4 instead of 5

PKG               := libechonest
$(PKG)_DEPS       := $(filter-out qtbase ,$($(PKG)_DEPS)) qt qjson
$(PKG)_QT_SUFFIX  :=
$(PKG)_QT4_BOOL   := ON
$(PKG)_BUILD_STATIC =

PKG               := opencsg
$(PKG)_DEPS       := $(filter-out qtbase ,$($(PKG)_DEPS)) qt
$(PKG)_QT_DIR     := qt

PKG               := openscenegraph
$(PKG)_DEPS       := $(filter-out qtbase ,$($(PKG)_DEPS)) qt

PKG               := qjson
$(PKG)_DEPS       := $(filter-out qtbase ,$($(PKG)_DEPS)) qt
$(PKG)_QT_SUFFIX  :=
$(PKG)_QT4_BOOL   := ON

PKG               := qwt
$(PKG)_DEPS       := cc qt
$(PKG)_QT_DIR     := qt

PKG               := qwtplot3d
$(PKG)_DEPS       := $(filter-out qtbase ,$($(PKG)_DEPS)) qt
$(PKG)_QT_DIR     := qt

PKG               := vtk
$(PKG)_DEPS       := cc hdf5 qt libpng expat libxml2 jsoncpp tiff freetype lz4 hdf5 libharu glew
$(PKG)_QT_VERSION := 4
