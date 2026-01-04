# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := nlopt
$(PKG)_WEBSITE  := https://nlopt.readthedocs.io/en/latest/
$(PKG)_DESCR    := NLopt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.10.0
$(PKG)_CHECKSUM := 506f83a9e778ad4f204446e99509cb2bdf5539de8beccc260a014bd560237be1
$(PKG)_GH_CONF  := stevengj/nlopt/releases/tags,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        -DNLOPT_PYTHON=OFF \
        -DNLOPT_OCTAVE=OFF \
        -DNLOPT_MATLAB=OFF \
        -DNLOPT_GUILE=OFF \
        -DNLOPT_SWIG=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1
endef
