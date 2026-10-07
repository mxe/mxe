# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := itk
$(PKG)_WEBSITE  := https://www.itk.org/
$(PKG)_DESCR    := Insight Segmentation and Registration Toolkit (ITK)
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.4.7
$(PKG)_CHECKSUM := c953ad7957c481dbb17cfebf03fc61e5252b2be7ccf6757d1234b48ac99914f8
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
        -DITK_USE_SYSTEM_ZLIB=TRUE \
        -DHAVE_CLOCK_GETTIME_RUN=TRUE \
        -Dhave_sse2_extensions_var_EXITCODE=TRUE \
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1
endef
