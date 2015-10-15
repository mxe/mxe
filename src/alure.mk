# This file is part of MXE.
# See index.html for further information.

PKG             := alure
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2
$(PKG)_CHECKSUM := 465e6adae68927be3a023903764662d64404e40c4c152d160e3a8838b1d70f71
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://kcat.strangesoft.net/alure-releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc flac libsndfile ogg openal vorbis

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

$(PKG)_BUILD_SHARED =
