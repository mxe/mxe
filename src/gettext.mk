# This file is part of MXE.
# See index.html for further information.

PKG             := gettext
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.18.3.2
$(PKG)_CHECKSUM := a2dc46d788edb0078ab20da7bd194bdb6da2f0d9
$(PKG)_SUBDIR   := gettext-$($(PKG)_VERSION)
$(PKG)_FILE     := gettext-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/gettext/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.gnu.org/software/gettext/' | \
    grep 'gettext-' | \
    $(SED) -n 's,.*gettext-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)/gettext-runtime' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-threads=win32 \
        --without-libexpat-prefix \
        --without-libxml2-prefix \
        CONFIG_SHELL=$(SHELL)
    $(MAKE) -C '$(1)/gettext-runtime/intl' -j '$(JOBS)' install
endef
