# This file is part of MXE.
# See index.html for further information.

PKG             := vtk6
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.0.0
$(PKG)_CHECKSUM := 51dd3b4a779d5442dd74375363f0f0c2d6eaf3fa
$(PKG)_SUBDIR   := VTK$($(PKG)_VERSION)
$(PKG)_FILE     := vtk-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.vtk.org/files/release/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc hdf5 qt

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://vtk.org/gitweb?p=VTK.git;a=tags' | \
    grep 'refs/tags/v[0-9.]*"' | \
    $(SED) 's,.*refs/tags/v\(.*\)".*,\1,g;' | \
    grep -v rc | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD

    # first we need a native build to create the compile tools
    mkdir '$(1).native_build'
    cd '$(1).native_build' && cmake \
        -DVTK_BUILD_ALL_MODULES=FALSE \
        -DVTK_Group_Rendering=FALSE \
        -DVTK_Group_StandAlone=FALSE \
        -DVTK_Group_CompileTools=TRUE \
        -DBUILD_TESTING=FALSE \
        -DCMAKE_BUILD_TYPE="Release" \
        '$(1)'
    $(MAKE) -C '$(1).native_build' -j '$(JOBS)' VERBOSE=1 vtkCompileTools

    # DirectX is detected on Mac OSX but we use OpenGL
    $(SED) -i 's,d3d9,nod3d9,g' '$(1)/CMake/FindDirectX.cmake'

    # now the cross compilation
    mkdir '$(1).cross_build'
    cd '$(1).cross_build' && cmake \
        -C '$(1)/TryRunResults.cmake' \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DVTKCompileTools_DIR='$(1).native_build' \
        -DBUILD_SHARED_LIBS=FALSE \
        -DModule_vtkGUISupportQt=TRUE \
        -DModule_vtkGUISupportQtOpenGL=TRUE \
        -DQT_QMAKE_EXECUTABLE=$(PREFIX)/$(TARGET)/qt/bin/qmake \
        -DVTK_USE_SYSTEM_HDF5=TRUE \
        -DBUILD_EXAMPLES=OFF \
        -DCMAKE_VERBOSE_MAKEFILE=TRUE \
        -DBUILD_TESTING=FALSE \
        '$(1)'
    $(MAKE) -C '$(1).cross_build' -j '$(JOBS)' install VERBOSE=1
endef

$(PKG)_BUILD_SHARED =
