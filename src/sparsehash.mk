# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sparsehash
$(PKG)_WEBSITE  := https://github.com/sparsehash/sparsehash
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.3
$(PKG)_CHECKSUM := 05e986a5c7327796dad742182b2d10805a8d4f511ad090da0490f146c1ff7a8c
$(PKG)_SUBDIR   := $(PKG)-$(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/$(PKG)/$(PKG)/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, sparsehash/sparsehash, sparsehash-)
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install $(MXE_DISABLE_DOCS)

    $(INSTALL) '$(1)/hashtable_test.exe' '$(PREFIX)/$(TARGET)/bin/test-sparsehash.exe'
    $(TARGET)-strip '$(PREFIX)/$(TARGET)/bin/test-sparsehash.exe'
endef
