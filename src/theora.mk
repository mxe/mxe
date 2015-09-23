# This file is part of MXE.
# See index.html for further information.

PKG             := theora
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.1
$(PKG)_CHECKSUM := 40952956c47811928d1e7922cda3bc1f427eb75680c3c37249c91e949054916b
$(PKG)_SUBDIR   := libtheora-$($(PKG)_VERSION)
$(PKG)_FILE     := libtheora-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://downloads.xiph.org/releases/theora/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc ogg vorbis

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.xiph.org/downloads/' | \
    $(SED) -n 's,.*libtheora-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # https://aur.archlinux.org/packages/mi/mingw-w64-libtheora/PKGBUILD
    $(SED) -i 's,EXPORTS,,' '$(1)/win32/xmingw32/libtheoradec-all.def'
    $(SED) -i 's,EXPORTS,,' '$(1)/win32/xmingw32/libtheoraenc-all.def'
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= doc_DATA=
endef
