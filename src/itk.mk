# This file is part of MXE.
# See index.html for further information.

PKG             := itk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.7
$(PKG)_CHECKSUM := 2e296335c437617c2a4eee50f87e1638f3d5a477
$(PKG)_SUBDIR   := a226067aaca0c8be89b49fee3ba03a04c60f0e16
$(PKG)_FILE     := $($(PKG)_SUBDIR).zip
$(PKG)_URL      := https://github.com/InsightSoftwareConsortium/ITK/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc hdf5 libpng tiff jpeg expat

define $(PKG)_UPDATE
    echo 'TODO: Updates for package ITK need to be written.' >&2;
    echo $(itk_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -C '$(1)/TryRunResults.cmake'\
        -DBUILD_SHARED_LIBS=ON \
        -DBUILD_TESTING=OFF \
        -DBUILD_EXAMPLES=OFF \
        -DITK_USE_SYSTEM_HDF5=ON \
        -DITK_USE_SYSTEM_TIFF=ON \
        -DITK_USE_SYSTEM_PNG=ON \
        -DITK_USE_SYSTEM_JPEG=ON \
        -DITK_USE_SYSTEM_EXPAT=ON \
        '$(1)'
   $(MAKE) -C '$(1).build' -j '$(JOBS)' install
endef
