# This file is part of MXE.
# See index.html for further information.

PKG             := flann
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.4
$(PKG)_CHECKSUM := e03d9d458757f70f6af1d330ff453e3621550a4f
$(PKG)_SUBDIR   := flann-$($(PKG)_VERSION)-src
$(PKG)_FILE     := flann-$($(PKG)_VERSION)-src.zip
$(PKG)_URL      := http://people.cs.ubc.ca/~mariusm/uploads/FLANN/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libgomp

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://people.cs.ubc.ca/~mariusm/index.php/FLANN/Changelog' | \
    grep 'Version' | \
    $(SED) -n 's,.*Version.\([0-9.]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD_SHARED
    # workaround for strange "too many sections" error
    # setting CXXFLAGS='-O3' seems to fix it
    # similar to http://www.mail-archive.com/mingw-w64-public@lists.sourceforge.net/msg06329.html
    cd '$(1)' && CXXFLAGS='-O3' cmake . \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_BUILD_TYPE=Release \
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
