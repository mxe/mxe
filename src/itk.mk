# This file is part of MXE.
# See index.html for further information.

PKG             := itk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.6.0
$(PKG)_CHECKSUM := 490d221bd7441ef1d151092a72082998c597308e
$(PKG)_SUBDIR   := InsightToolkit-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.xz
$(PKG)_URL      := http://sourceforge.net/projects/$(PKG)/files/$(PKG)/4.6/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc hdf5 libpng tiff jpeg expat

#git commit 3d95bcf
define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/itk/files/itk/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
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
