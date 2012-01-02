# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# file
PKG             := file
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.10
$(PKG)_CHECKSUM := 72fd435e78955ee122b7b3d323ff2f92e6263e89
$(PKG)_SUBDIR   := file-$($(PKG)_VERSION)
$(PKG)_FILE     := file-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.darwinsys.com/file/
$(PKG)_URL      := ftp://ftp.astron.com/pub/file/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libgnurx

define $(PKG)_UPDATE
    wget -q -O- 'ftp://ftp.astron.com/pub/file/' | \
    grep 'file-' | \
    $(SED) -n 's,.*file-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    # "file" needs a runnable version of the "file" utility
    # itself. This must match the source code regarding its
    # version. Therefore we build a native one ourselves first.

    cd '$(1)' && ./configure \
        --disable-shared
    $(MAKE) -C '$(1)/src' -j '$(JOBS)' file
    cp '$(1)/src/file' '$(1)/src/file.local'

    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' clean
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
