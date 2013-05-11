# This file is part of MXE.
# See index.html for further information

PKG             := alure
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := f033f0820c449ebff7b4b0254a7b1f26c0ba485b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://kcat.strangesoft.net/alure-releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc openal flac ogg libsndfile vorbis

define $(PKG)_UPDATE
    $(WGET) -q -O- http://repo.or.cz/w/alure.git/tags | \
    grep alure- | \
    $(SED) -n 's,.*alure-\([0-9\.]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)/build' && cmake \
        -DBUILD_STATIC=ON \
        -DBUILD_SHARED=OFF \
        -DBUILD_EXAMPLES=OFF \
        -DCMAKE_C_FLAGS="-DAL_LIBTYPE_STATIC -DALURE_STATIC_LIBRARY" \
        -DCMAKE_CXX_FLAGS="-DAL_LIBTYPE_STATIC -DALURE_STATIC_LIBRARY" \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        ..
    $(MAKE) -C '$(1)/build' -j $(JOBS) VERBOSE=1
    $(MAKE) -C '$(1)/build' -j $(JOBS) install
endef

