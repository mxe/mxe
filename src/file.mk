# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := file
$(PKG)_WEBSITE  := https://www.darwinsys.com/file/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.24
$(PKG)_CHECKSUM := 802cb3de2e49e88ef97cdcb52cd507a0f25458112752e398445cea102bc750ce
$(PKG)_SUBDIR   := file-$($(PKG)_VERSION)
$(PKG)_FILE     := file-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://distfiles.macports.org/file/$($(PKG)_FILE)
# astron.com is down
# $(PKG)_URL_2    := ftp://ftp.astron.com/pub/file/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libgnurx

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://distfiles.macports.org/file/' | \
    grep 'file-' | \
    $(SED) -n 's,.*file-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi

    # "file" needs a runnable version of the "file" utility
    # itself. This must match the source code regarding its
    # version. Therefore we build a native one ourselves first.

    cp -Rp '$(1)' '$(1).native'
    cd '$(1).native' && ./configure \
        --disable-shared
    $(MAKE) -C '$(1).native/src' -j '$(JOBS)' file

    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        CFLAGS=-DHAVE_PREAD
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS= FILE_COMPILE='$(1).native/src/file'
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-file.exe' \
        -lmagic -lgnurx -lshlwapi
endef
