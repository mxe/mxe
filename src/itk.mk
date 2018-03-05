# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := itk
$(PKG)_WEBSITE  := https://www.itk.org/
$(PKG)_DESCR    := Insight Segmentation and Registration Toolkit (ITK)
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.10.1
$(PKG)_CHECKSUM := 334312cc31925fd6c2622c9cd4ed33fecbbbd5b97e03b93f34b259d08352eed7
$(PKG)_SUBDIR   := InsightToolkit-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.xz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc expat hdf5 jpeg libpng tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://itk.org/ITK/resources/software.html' | \
    $(SED) -n 's,.*InsightToolkit-\([0-9][^>]*\)\.tar\.xz.*,\1,p' | \
    $(SORT) -V |
    tail -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && '$(TARGET)-cmake' \
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
