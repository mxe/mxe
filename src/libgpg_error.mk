# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libgpg_error
$(PKG)_WEBSITE  := https://www.gnupg.org/related_software/libgpg-error/
$(PKG)_DESCR    := libgpg-error
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.34
$(PKG)_CHECKSUM := 0680799dee71b86b2f435efb825391eb040ce2704b057f6bd3dcc47fbc398c81
$(PKG)_SUBDIR   := libgpg-error-$($(PKG)_VERSION)
$(PKG)_FILE     := libgpg-error-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://gnupg.org/ftp/gcrypt/libgpg-error/$($(PKG)_FILE)
$(PKG)_URL_2    := https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libgpg-error/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gettext

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gnupg.org/ftp/gcrypt/libgpg-error/' | \
    $(SED) -n 's,.*libgpg-error-\([1-9]\.[1-9][0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)/src/syscfg' && ln -s lock-obj-pub.mingw32.h lock-obj-pub.mingw32.$(call merge,.,$(call rest,$(call split,.,$(TARGET)))).h
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-nls \
        --disable-languages
    $(SED) -i 's/host_os = mingw32.*/host_os = mingw32/' '$(1)/src/Makefile'
    $(MAKE) -C '$(1)/src' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(SED) -i 's/-lgpg-error/-lgpg-error -lintl -liconv -lws2_32/;' '$(1)/src/gpg-error-config'
    $(MAKE) -C '$(1)/src' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    ln -sf '$(PREFIX)/$(TARGET)/bin/gpg-error-config' '$(PREFIX)/bin/$(TARGET)-gpg-error-config'
endef
