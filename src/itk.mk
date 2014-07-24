# This file is part of MXE.
# See index.html for further information.

PKG             := itk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3d95bcf
$(PKG)_CHECKSUM := 564f93955b856d019864ae25a14de68c0ac53577
$(PKG)_SUBDIR   := InsightToolkit-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := http://localhost/tmp-win-sources/$($(PKG)_FILE)
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
