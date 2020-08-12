# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pcl
$(PKG)_WEBSITE  := http://www.pointclouds.org/
$(PKG)_DESCR    := PCL (Point Cloud Library)
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.9.1
$(PKG)_CHECKSUM := 0add34d53cd27f8c468a59b8e931a636ad3174b60581c0387abb98a9fc9cddb6
$(PKG)_SUBDIR   := $(PKG)-$(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/PointCloudLibrary/pcl/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := cc boost eigen flann vtk

define $(PKG)_UPDATE
    $(WGET) -q -O- "https://github.com/PointCloudLibrary/pcl/releases" | \
    grep '<a href=.*tar' | \
    $(SED) -n 's,.*pcl-\([0-9.]\+\)\.tar.*,\1,p' | \
    head -1
endef

# There is a strange problem where including <cfloat> leads to an error
# in some of the #include_next magic with float.h.
# We work around this by avoiding an #include_next in MinGW's float.h
# (by defining __FLOAT_H) and then manually defining the MIN/MAX macros
# that PCL wants to use.

define $(PKG)_BUILD
    find '$(SOURCE_DIR)' -type f -name CMakeLists.txt -exec $(SED) -i -e 's/Rpcrt4/rpcrt4/g' {} \;
    cd '$(BUILD_DIR)' && \
        CXXFLAGS="-D__FLOAT_H -DFLT_MAX=__FLT_MAX__ -DFLT_MIN=__FLT_MIN__ -DDBL_MAX=__DBL_MAX__ -DDBL_MIN=__DBL_MIN__ -DDBL_EPSILON=__DBL_EPSILON__" \
        '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DCMAKE_RELEASE_POSTFIX='' \
        -DBoost_THREADAPI=win32 \
        -DPCL_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
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
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' -k -l '$(JOBS)' VERBOSE=1 || $(MAKE) -C '$(BUILD_DIR)' -j 1 -l 1 VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1
endef
