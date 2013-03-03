# This file is part of MXE.
# See index.html for further information.

PKG             := libgnurx
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := f1e4af2541645dac82362b618aaa849658cd4988
$(PKG)_SUBDIR   := mingw-libgnurx-$($(PKG)_VERSION)
$(PKG)_FILE     := mingw-libgnurx-$($(PKG)_VERSION)-src.tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/mingw/Other/UserContributed/regex/mingw-regex-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/mingw/files/Other/UserContributed/regex/' | \
    grep 'mingw-regex-' | \
    $(SED) -n 's,.*mingw-regex-\([0-9\.]*\).*,\1,p' | \
    sort | \
    uniq | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -f Makefile.mxe -j '$(JOBS)' TARGET=$(TARGET) bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= install-static
    ln -sf '$(PREFIX)/$(TARGET)/lib/libgnurx.a' '$(PREFIX)/$(TARGET)/lib/libregex.a'
endef
