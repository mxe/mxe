# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libgnurx
$(PKG)_WEBSITE  := https://sourceforge.net/projects/mingw/files/UserContributed/regex/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.6.1
$(PKG)_CHECKSUM := ee6edc110c6b63d0469f4f05ef187564b310cc8a88b6566310a4aebd48b612c7
$(PKG)_SUBDIR   := mingw-libgnurx-$($(PKG)_VERSION)
$(PKG)_FILE     := mingw-libgnurx-$($(PKG)_VERSION)-src.tar.gz
$(PKG)_URL      := https://github.com/TimothyGu/libgnurx/releases/download/libgnurx-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://api.github.com/repos/TimothyGu/libgnurx/git/refs/tags/' \
    | $(SED) -n 's#.*"ref": "refs/tags/libgnurx-\([^"]*\).*#\1#p' \
    | $(SORT) -V \
    | tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -f Makefile.mxe -j '$(JOBS)' \
        $(if $(BUILD_STATIC),install-static,install-shared) \
        TARGET=$(TARGET) bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
