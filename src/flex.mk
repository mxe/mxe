# This file is part of MXE.
# See index.html for further information.

PKG             := flex
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5.37
$(PKG)_CHECKSUM := db4b140f2aff34c6197cab919828cc4146aae218
$(PKG)_SUBDIR   := flex-$($(PKG)_VERSION)
$(PKG)_FILE     := flex-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://prdownloads.sourceforge.net/flex/$($(PKG)_FILE)
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
