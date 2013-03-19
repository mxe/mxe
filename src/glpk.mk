# This file is part of MXE.
# See index.html for further information.

PKG             := glpk
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 35e16d3167389b6bc75eb51b4b48590db59f789c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := glpk-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/gnu/glpk/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package glpk.' >&2;
    echo $(glpk_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && aclocal && libtoolize && autoreconf
    mkdir '$(1)/.build'
    cd '$(1)/.build' && '$(1)/configure' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install
endef
