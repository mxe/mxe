# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := yasm
$(PKG)_WEBSITE  := https://yasm.tortall.net/
$(PKG)_DESCR    := Yasm
$(PKG)_VERSION  := 1.3.0
$(PKG)_CHECKSUM := 3dce6601b495f5b3d45b59f7d2492a340ee7e84b5beca17e48f862502bd5603f
$(PKG)_GH_CONF  := yasm/yasm/tags, v
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.tortall.net/projects/$(PKG)/releases/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := cc $(BUILD)~$(PKG)

$(PKG)_DEPS_$(BUILD) :=

define $(PKG)_BUILD
    # link to native yasm compiler on cross builds - it isn't
    # target-specific but makes it easier to detect our version
    $(if $(BUILD_CROSS),
        ln -sf '$(PREFIX)/$(BUILD)/bin/yasm' '$(PREFIX)/bin/$(TARGET)-yasm')

    # yasm is always static
    # build libyasm and tools
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --disable-nls \
        --disable-python
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
