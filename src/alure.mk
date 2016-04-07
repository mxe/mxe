# This file is part of MXE.
# See index.html for further information.

PKG             := alure
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2
$(PKG)_CHECKSUM := 465e6adae68927be3a023903764662d64404e40c4c152d160e3a8838b1d70f71
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://kcat.strangesoft.net/alure-releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc flac libsndfile mpg123 ogg openal vorbis

define $(PKG)_UPDATE
    $(WGET) -q -O- http://repo.or.cz/w/alure.git/tags | \
    grep alure- | \
    $(SED) -n 's,.*alure-\([0-9\.]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    '$(TARGET)-cmake' -B'$(BUILD_DIR)' -H'$(SOURCE_DIR)' \
        -DBUILD_EXAMPLES=OFF \
        -DFLUIDSYNTH=OFF \
        $(if $(BUILD_STATIC), \
            -DCMAKE_C_FLAGS="-DAL_LIBTYPE_STATIC -DALURE_STATIC_LIBRARY" \
            -DCMAKE_CXX_FLAGS="-DAL_LIBTYPE_STATIC -DALURE_STATIC_LIBRARY")

    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS) VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS) install

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(SOURCE_DIR)/examples/alurestream.c' \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' alure$(if $(BUILD_STATIC),-static) \
        flac libmpg123 sndfile vorbisfile --cflags --libs`
endef
