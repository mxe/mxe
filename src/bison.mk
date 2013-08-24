# This file is part of MXE.
# See index.html for further information.

PKG             := bison
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.7.1
$(PKG)_CHECKSUM := 00ab1b32d864622077c311e4f5420d4e2931fdc8
$(PKG)_SUBDIR   := bison-$($(PKG)_VERSION)
$(PKG)_FILE     := bison-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/bison/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD_NATIVE
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(PREFIX)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef
