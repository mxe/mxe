# This file is part of MXE.
# See index.html for further information.

PKG             := file
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 64ae9f7d32a35409b22ad54187b90d2a6d6a42c5
$(PKG)_SUBDIR   := file-$($(PKG)_VERSION)
$(PKG)_FILE     := file-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.astron.com/pub/file/$($(PKG)_FILE)
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
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS= FILE_COMPILE='$(1).native/src/file'
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-file.exe' \
        -lmagic -lgnurx -lshlwapi
endef

$(PKG)_BUILD_x86_64-w64-mingw32 =
$(PKG)_BUILD_i686-w64-mingw32 =
