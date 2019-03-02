# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := itk
$(PKG)_WEBSITE  := https://www.itk.org/
$(PKG)_DESCR    := Insight Segmentation and Registration Toolkit (ITK)
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.13.1
$(PKG)_CHECKSUM := b352060d8b7289916a3cb033dfdbcf423423ba474643b79706966e679268e3d7
$(PKG)_GH_CONF  := InsightSoftwareConsortium/ITK/releases/latest, v
$(PKG)_DEPS     := cc expat hdf5 jpeg libpng tiff zlib

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
