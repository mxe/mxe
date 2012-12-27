# This file is part of MXE.
# See index.html for further information.

PKG             := flann
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 61b9858620528919ea60a2a4b085ccc2b3c2d138
$(PKG)_SUBDIR   := flann-$($(PKG)_VERSION)-src
$(PKG)_FILE     := flann-$($(PKG)_VERSION)-src.zip
$(PKG)_URL      := http://people.cs.ubc.ca/~mariusm/uploads/FLANN/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://people.cs.ubc.ca/~mariusm/index.php/FLANN/Changelog' | \
    grep 'Version' | \
    $(SED) -n 's,.*Version.\([0-9.]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake . \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_CUDA_LIB=OFF \
        -DBUILD_MATLAB_BINDINGS=OFF \
        -DBUILD_PYTHON_BINDINGS=OFF
    $(MAKE) -C '$(1)' -j '$(JOBS)' install VERBOSE=1
endef
