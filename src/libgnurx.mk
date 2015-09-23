# This file is part of MXE.
# See index.html for further information.

PKG             := libgnurx
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5.1
$(PKG)_CHECKSUM := 7147b7f806ec3d007843b38e19f42a5b7c65894a57ffc297a76b0dcd5f675d76
$(PKG)_SUBDIR   := mingw-libgnurx-$($(PKG)_VERSION)
$(PKG)_FILE     := mingw-libgnurx-$($(PKG)_VERSION)-src.tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/mingw/Other/UserContributed/regex/mingw-regex-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/mingw/files/Other/UserContributed/regex/' | \
    grep 'mingw-regex-' | \
    $(SED) -n 's,.*mingw-regex-\([0-9\.]*\).*,\1,p' | \
    $(SORT) | \
    uniq | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -f Makefile.mxe -j '$(JOBS)' \
        $(if $(BUILD_STATIC),install-static,install-shared) \
        TARGET=$(TARGET) bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
