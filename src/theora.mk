# This file is part of MXE.
# See index.html for further information.

PKG             := theora
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 0b91be522746a29351a5ee592fd8160940059303
$(PKG)_SUBDIR   := libtheora-$($(PKG)_VERSION)
$(PKG)_FILE     := libtheora-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://downloads.xiph.org/releases/theora/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc ogg vorbis

define $(PKG)_UPDATE
    wget -q -O- 'http://www.xiph.org/downloads/' | \
    $(SED) -n 's,.*libtheora-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        $(LINK_STYLE) \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= doc_DATA=
endef

$(PKG)_BUILD_i686-static-mingw32   = $($(PKG)_BUILD)
$(PKG)_BUILD_x86_64-static-mingw32 = $($(PKG)_BUILD)
