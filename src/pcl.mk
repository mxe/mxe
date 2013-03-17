# This file is part of MXE.
# See index.html for further information.

PKG             := pcl
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 45a2e155d7faf5901abe609fd40d5f1659015e9e
$(PKG)_SUBDIR   := PCL-$($(PKG)_VERSION)-Source
$(PKG)_FILE     := PCL-$($(PKG)_VERSION)-Source.tar.bz2
$(PKG)_URL      := http://www.pointclouds.org/assets/files/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libgomp boost eigen flann vtk

define $(PKG)_UPDATE
    $(WGET) -q -O- "http://www.pointclouds.org/downloads/" | \
    grep '<a href=.*tar' | \
    $(SED) -n 's,.*PCL-\([0-9][^>]*\)-Source.*,\1,p' | \
    head -1
endef

# There is a strange problem where including <cfloat> leads to an error
# in some of the #include_next magic with float.h.
# We work around this by avoiding an #include_next in MinGW's float.h
# (by defining __FLOAT_H) and then manually defining the MIN/MAX macros
# that PCL wants to use.

define $(PKG)_BUILD
    cd '$(1)' && \
        CXXFLAGS="-D__FLOAT_H -DFLT_MAX=__FLT_MAX__ -DFLT_MIN=__FLT_MIN__ -DDBL_MAX=__DBL_MAX__ -DDBL_MIN=__DBL_MIN__" \
        cmake . \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_RELEASE_POSTFIX='' \
        -DBoost_THREADAPI=win32 \
        -DPCL_SHARED_LIBS=OFF \
        -DBUILD_TESTS=OFF \
        -DBUILD_apps=OFF \
        -DBUILD_examples=OFF \
        -DBUILD_global_tests=OFF \
        -DBUILD_tools=OFF
    $(MAKE) -C '$(1)' -j '$(JOBS)' VERBOSE=1 || $(MAKE) -C '$(1)' -j 1 VERBOSE=1
    $(MAKE) -C '$(1)' -j 1 install VERBOSE=1
endef
