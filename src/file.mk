# This file is part of MXE.
# See index.html for further information.

PKG             := file
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.19
$(PKG)_CHECKSUM := 0dff09eb44fde1998be79e8d312e9be4456d31ee
$(PKG)_SUBDIR   := file-$($(PKG)_VERSION)
$(PKG)_FILE     := file-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.cross-lfs.org/pub/clfs/conglomeration/file/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.astron.com/pub/file/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libgnurx

define $(PKG)_UPDATE
    $(WGET) -q -O- 'ftp://ftp.astron.com/pub/file/' | \
    grep 'file-' | \
    $(SED) -n 's,.*file-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
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
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-file.exe' \
        -lmagic -lgnurx -lshlwapi
endef
