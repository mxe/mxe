# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := alure
$(PKG)_WEBSITE  := https://kcat.strangesoft.net/alure.html
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2
$(PKG)_CHECKSUM := 465e6adae68927be3a023903764662d64404e40c4c152d160e3a8838b1d70f71
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://kcat.strangesoft.net/alure-releases/$($(PKG)_FILE)
$(PKG)_DEPS     := cc flac libsndfile mpg123 ogg openal vorbis

define $(PKG)_UPDATE
    $(WGET) -q -O- https://repo.or.cz/alure.git/tags | \
    grep alure- | \
    $(SED) -n 's,.*alure-\([0-9\.]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DDYNLOAD=$(CMAKE_SHARED_BOOL) \
        -DBUILD_SHARED=$(CMAKE_SHARED_BOOL) \
        -DBUILD_STATIC=$(CMAKE_STATIC_BOOL) \
        -DBUILD_EXAMPLES=OFF \
        -DFLUIDSYNTH=OFF \
        -DSTATIC_CFLAGS="-DAL_LIBTYPE_STATIC"
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
