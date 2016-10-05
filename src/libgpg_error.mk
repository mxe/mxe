# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libgpg_error
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.24
$(PKG)_CHECKSUM := 9268e1cc487de5e6e4460fca612a06e4f383072ac43ae90603e5e46783d3e540
$(PKG)_SUBDIR   := libgpg-error-$($(PKG)_VERSION)
$(PKG)_FILE     := libgpg-error-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://mirrors.dotsrc.org/gcrypt/libgpg-error/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.gnupg.org/gcrypt/libgpg-error/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gettext

define $(PKG)_UPDATE
    $(WGET) -q -O- 'ftp://ftp.gnupg.org/gcrypt/libgpg-error/' | \
    $(SED) -n 's,.*libgpg-error-\([1-9]\.[1-9][0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)/src/syscfg' && ln -s lock-obj-pub.mingw32.h lock-obj-pub.mingw32.static.h
    cd '$(1)/src/syscfg' && ln -s lock-obj-pub.mingw32.h lock-obj-pub.mingw32.shared.h
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-nls \
        --disable-languages
    $(SED) -i 's/-lgpg-error/-lgpg-error -lintl -liconv/;' '$(1)/src/gpg-error-config'
    $(SED) -i 's/host_os = mingw32.*/host_os = mingw32/' '$(1)/src/Makefile'
    $(MAKE) -C '$(1)/src' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)/src' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    ln -sf '$(PREFIX)/$(TARGET)/bin/gpg-error-config' '$(PREFIX)/bin/$(TARGET)-gpg-error-config'
endef
