# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# ATLAS
PKG             := atlas
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.8.3
$(PKG)_CHECKSUM := c7546210df4796457d9e96a00444adc4c0f2e77f
$(PKG)_SUBDIR   := ATLAS
$(PKG)_FILE     := $(PKG)$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://math-atlas.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/math-atlas/Stable/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    # seems to use even/odd development versioning
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && '$(1)'/configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --cc='$(TARGET)-gcc'
    $(MAKE) -C '$(1).build' -j 1 install
endef
