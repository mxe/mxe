# This file is part of MXE.
# See index.html for further information.

PKG             := vtk
$(PKG)_IGNORE   := 5.10%
$(PKG)_VERSION  := 5.8.0
$(PKG)_CHECKSUM := 83ee74b83403590342c079a52b06eef7ab862417f941d5f4558aea25c6bbc2d5
$(PKG)_SUBDIR   := VTK
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.vtk.org/files/release/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc expat freetype hdf5 jpeg libodbc++ libpng libxml2 postgresql qt tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://vtk.org/gitweb?p=VTK.git;a=tags' | \
    grep 'refs/tags/v5[0-9.]*"' | \
    $(SED) 's,.*refs/tags/v\(.*\)".*,\1,g;' | \
    head -1
endef

define $(PKG)_BUILD

    # first we need a native build to create the compile tools
    mkdir '$(1)/native_build'
    cd '$(1)/native_build' && cmake \
        -DBUILD_TESTING=FALSE \
        -DOPENGL_INCLUDE_DIR='$(1)/Utilities/ParseOGLExt/headers' \
        -DVTK_USE_RENDERING=FALSE \
        ..

    # only the newly created CompileTools target need to be built
    $(MAKE) -C '$(1)/native_build' -j '$(JOBS)' VERBOSE=1 CompileTools

    # DirectX is detected on Mac OSX but requires a DX10 header - dxgi.h
    rm '$(1)/CMake/FindDirectX.cmake'

    # now for the cross compilation
    mkdir '$(1)/cross_build'
    cd '$(1)/cross_build' && cmake \
        -C '$(1)/TryRunResults.cmake'\
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'\
        -DBUILD_TESTING=FALSE\
        -DVTKCompileTools_DIR='$(1)/native_build'\
        -DVTK_USE_SYSTEM_EXPAT=TRUE\
        -DVTK_USE_SYSTEM_FREETYPE=FALSE\
        -DVTK_USE_SYSTEM_HDF5=TRUE \
        -DVTK_USE_SYSTEM_JPEG=TRUE\
        -DVTK_USE_SYSTEM_LIBXML2=TRUE\
        -DVTK_USE_SYSTEM_PNG=TRUE\
        -DVTK_USE_SYSTEM_TIFF=TRUE\
        -DVTK_USE_SYSTEM_ZLIB=TRUE\
        -DVTK_USE_QT=TRUE\
        -DVTK_USE_POSTGRES=TRUE\
        -DVTK_USE_ODBC=TRUE\
        ..
    $(MAKE) -C '$(1)/cross_build' -j '$(JOBS)' VERBOSE=1 || $(MAKE) -C '$(1)/cross_build' -j 1 VERBOSE=1
    $(MAKE) -C '$(1)/cross_build' -j 1 install VERBOSE=1
endef

$(PKG)_BUILD_SHARED =
