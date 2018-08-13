# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := itk
$(PKG)_WEBSITE  := https://www.itk.org/
$(PKG)_DESCR    := Insight Segmentation and Registration Toolkit (ITK)
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.13.0
$(PKG)_CHECKSUM := feb3fce3cd3bf08405e49da30876dc766e5145c821e5e3f8736df1d1717da125
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
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DCMAKE_VERBOSE_MAKEFILE=TRUE \
        -DITK_FORBID_DOWNLOADS=TRUE \
        -DBUILD_TESTING=FALSE \
        -DBUILD_EXAMPLES=FALSE \
        -DITK_USE_SYSTEM_EXPAT=TRUE \
        -DITK_USE_SYSTEM_HDF5=TRUE \
        -DITK_USE_SYSTEM_JPEG=TRUE \
        -DITK_USE_SYSTEM_PNG=TRUE \
        -DITK_USE_SYSTEM_TIFF=TRUE \
        -DITK_USE_SYSTEM_ZLIB=TRUE
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1
endef
