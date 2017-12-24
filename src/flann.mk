# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := flann
$(PKG)_WEBSITE  := https://www.cs.ubc.ca/~mariusm/index.php/FLANN/FLANN
$(PKG)_DESCR    := FLANN
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.4
$(PKG)_CHECKSUM := dfbb9321b0d687626a644c70872a2c540b16200e7f4c7bd72f91ae032f445c08
$(PKG)_SUBDIR   := flann-$($(PKG)_VERSION)-src
$(PKG)_FILE     := flann-$($(PKG)_VERSION)-src.zip
$(PKG)_URL      := https://www.cs.ubc.ca/research/flann/uploads/FLANN/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.cs.ubc.ca/research/flann/index.php/FLANN/Changelog' | \
    grep 'Version' | \
    $(SED) -n 's,.*Version.\([0-9.]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD_SHARED
    # workaround for strange "too many sections" error
    # setting CXXFLAGS='-O3' seems to fix it
    # similar to https://www.mail-archive.com/mingw-w64-public@lists.sourceforge.net/msg06329.html
    cd '$(1)' && CXXFLAGS='-O3' '$(TARGET)-cmake' . \
        -DBUILD_CUDA_LIB=OFF \
        -DBUILD_MATLAB_BINDINGS=OFF \
        -DBUILD_PYTHON_BINDINGS=OFF  \
        -DUSE_OPENMP=ON
    $(MAKE) -C '$(1)' -j '$(JOBS)' install VERBOSE=1
endef

define $(PKG)_BUILD
    $($(PKG)_BUILD_SHARED)
    for l in flann flann_cpp; do \
        ln -sf '$(PREFIX)/$(TARGET)'/lib/lib$$l.a \
            '$(PREFIX)/$(TARGET)'/lib/lib$${l}_s.a ; \
    done
endef
