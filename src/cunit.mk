# This file is part of MXE.
# See index.html for further information.

PKG             := cunit
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1-3
$(PKG)_CHECKSUM := eac0c71167aa3fab83483ae1313b78163f0f7238
$(PKG)_SUBDIR   := CUnit-$($(PKG)_VERSION)
$(PKG)_FILE     := CUnit-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/cunit/CUnit/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/cunit/files/CUnit/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
endef

$(PKG)_BUILD_SHARED =
