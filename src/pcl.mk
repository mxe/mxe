# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pcl
$(PKG)_WEBSITE  := http://www.pointclouds.org/
$(PKG)_DESCR    := PCL (Point Cloud Library)
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.0
$(PKG)_CHECKSUM := 9e54b0c1b59a67a386b9b0f4acb2d764272ff9a0377b825c4ed5eedf46ebfcf4
$(PKG)_SUBDIR   := $(PKG)-$(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/PointCloudLibrary/pcl/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc boost eigen flann vtk

define $(PKG)_UPDATE
    $(WGET) -q -O- "https://github.com/PointCloudLibrary/pcl/releases" | \
    grep '<a href=.*tar' | \
    $(SED) -n 's,.*pcl-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DMXE_DISABLE_INCLUDE_SYSTEM_FLAG=TRUE \
        -DCMAKE_RELEASE_POSTFIX='' \
        -DBoost_THREADAPI=win32 \
        -DPCL_SHARED_LIBS=OFF \
        -DBUILD_TESTS=OFF \
        -DBUILD_apps=OFF \
        -DBUILD_examples=OFF \
        -DBUILD_global_tests=OFF \
        -DBUILD_tools=OFF \
        -DWITH_CUDA=OFF \
        -DWITH_PCAP=OFF \
        -DHAVE_MM_MALLOC_EXITCODE=0 \
        -DHAVE_SSE4_2_EXTENSIONS_EXITCODE=0 \
        -DHAVE_SSE4_1_EXTENSIONS_EXITCODE=0 \
        -DHAVE_SSSE3_EXTENSIONS_EXITCODE=0 \
        -DHAVE_SSE3_EXTENSIONS_EXITCODE=0 \
        -DHAVE_SSE2_EXTENSIONS_EXITCODE=0 \
        -DHAVE_SSE_EXTENSIONS_EXITCODE=0
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1 || $(MAKE) -C '$(BUILD_DIR)' -j 1 VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1
endef

$(PKG)_BUILD_SHARED =
