# This file is part of MXE.
# See index.html for further information.

PKG             := pcl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.7.2
$(PKG)_CHECKSUM := 479f84f2c658a6319b78271111251b4c2d6cf07643421b66bbc351d9bed0ae93
$(PKG)_SUBDIR   := $(PKG)-$(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/PointCloudLibrary/pcl/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc boost eigen flann libgomp vtk

define $(PKG)_UPDATE
    $(WGET) -q -O- "https://github.com/PointCloudLibrary/pcl/releases" | \
    grep '<a href=.*tar' | \
    $(SED) -n 's,.*pcl-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

# There is a strange problem where including <cfloat> leads to an error
# in some of the #include_next magic with float.h.
# We work around this by avoiding an #include_next in MinGW's float.h
# (by defining __FLOAT_H) and then manually defining the MIN/MAX macros
# that PCL wants to use.

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && \
        CXXFLAGS="-D__FLOAT_H -DFLT_MAX=__FLT_MAX__ -DFLT_MIN=__FLT_MIN__ -DDBL_MAX=__DBL_MAX__ -DDBL_MIN=__DBL_MIN__ -DDBL_EPSILON=__DBL_EPSILON__" \
        cmake '$(1)' \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DVTK_DIR='$(PREFIX)/$(TARGET)/lib/vtk-5.8' \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_RELEASE_POSTFIX='' \
        -DBoost_THREADAPI=win32 \
        -DPCL_SHARED_LIBS=OFF \
        -DBUILD_TESTS=OFF \
        -DBUILD_apps=OFF \
        -DBUILD_examples=OFF \
        -DBUILD_global_tests=OFF \
        -DBUILD_tools=OFF \
        -DWITH_PCAP=OFF \
        -DHAVE_MM_MALLOC_EXITCODE=0 \
        -DHAVE_SSE4_2_EXTENSIONS_EXITCODE=0 \
        -DHAVE_SSE4_1_EXTENSIONS_EXITCODE=0 \
        -DHAVE_SSE3_EXTENSIONS_EXITCODE=0 \
        -DHAVE_SSE2_EXTENSIONS_EXITCODE=0 \
        -DHAVE_SSE_EXTENSIONS_EXITCODE=0
    $(MAKE) -C '$(1).build' -j '$(JOBS)' VERBOSE=1 || $(MAKE) -C '$(1).build' -j 1 VERBOSE=1
    $(MAKE) -C '$(1).build' -j 1 install VERBOSE=1
endef

$(PKG)_BUILD_SHARED =
