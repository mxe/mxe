# This file is part of MXE.
# See index.html for further information.

PKG             := itk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.8.2
$(PKG)_CHECKSUM := fec268ba180bdb78d760aa4f6f467d0a5fc71b3a34e3201d8425d0edfa23ef5f
$(PKG)_SUBDIR   := InsightToolkit-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.xz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc expat hdf5 jpeg libpng tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://itk.org/ITK/resources/software.html' | \
    $(SED) -n 's,.*InsightToolkit-\([0-9][^>]*\)\.tar\.xz.*,\1,p' | \
    $(SORT) -V |
    tail -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && '$(TARGET)-cmake' \
        -DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        -DCMAKE_VERBOSE_MAKEFILE=TRUE \
        -DITK_FORBID_DOWNLOADS=TRUE \
        -DBUILD_TESTING=FALSE \
        -DBUILD_EXAMPLES=FALSE \
        -DITK_USE_SYSTEM_EXPAT=TRUE \
        -DITK_USE_SYSTEM_HDF5=TRUE \
        -DITK_USE_SYSTEM_JPEG=TRUE \
        -DITK_USE_SYSTEM_PNG=TRUE \
        -DITK_USE_SYSTEM_TIFF=TRUE \
        -DITK_USE_SYSTEM_ZLIB=TRUE \
        '$(1)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)' install VERBOSE=1
endef
