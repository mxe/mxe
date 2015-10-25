# This file is part of MXE.
# See index.html for further information.

PKG             := yasm
$(PKG)_VERSION  := 1.3.0
$(PKG)_CHECKSUM := 3dce6601b495f5b3d45b59f7d2492a340ee7e84b5beca17e48f862502bd5603f
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.tortall.net/projects/$(PKG)/releases/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := gcc

$(PKG)_DEPS_$(BUILD) :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/yasm/yasm/tags' | \
    $(SED) -n 's,.*href="/yasm/yasm/archive/v\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # link to native yasm compiler on cross builds
    $(if $(call sne,$(TARGET),$(BUILD)),
        ln -sf '$(PREFIX)/$(BUILD)/bin/yasm' '$(PREFIX)/bin/$(TARGET)-yasm')

    # yasm is always static
    cd '$(1)' && '$(1)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --disable-nls \
        --disable-python
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
