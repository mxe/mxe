# This file is part of MXE.
# See index.html for further information.

PKG             := vtk6
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 6d62715dee16d34d7d9bd9a3edc4d32a39d7c2d0
$(PKG)_SUBDIR   := VTK$($(PKG)_VERSION)
$(PKG)_FILE     := vtk-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.vtk.org/files/release/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qt

define $(PKG)_UPDATE
endef

define $(PKG)_BUILD

    # first we need a native build to create the compile tools
    mkdir '$(1)/native_build'
    cd '$(1)/native_build' && cmake \
        -DBUILD_TESTING=FALSE \
        -DVTK_USE_RENDERING=FALSE \
        ..
    $(MAKE) -C '$(1)/native_build' -j '$(JOBS)' VERBOSE=1 vtkCompileTools

    # now the cross compilation
    mkdir '$(1)/cross_build'
    cd '$(1)/cross_build' && cmake \
        -C '$(1)/TryRunResults.cmake'\
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'\
        -DVTKCompileTools_DIR='$(1)/native_build'\
		-DBUILD_SHARED_LIBS=FALSE\
		-DModule_vtkGUISupportQt=TRUE\
		-DModule_vtkGUISupportQtOpenGL=TRUE\
		-DQT_QMAKE_EXECUTABLE=$(PREFIX)/$(TARGET)/qt/bin/qmake\
        -DBUILD_EXAMPLES=FALSE\
        -DCMAKE_VERBOSE_MAKEFILE=TRUE\
        -DBUILD_TESTING=FALSE\
        ..
    $(MAKE) -C '$(1)/cross_build' -j '$(JOBS)' install VERBOSE=1
endef

