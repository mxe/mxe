# This file is part of MXE.
# See index.html for further information.

PKG                  := libtool
$(PKG)_TARGETS       := $(BUILD)
$(PKG)_DEPS_$(BUILD) := autoconf automake

define $(PKG)_BUILD_$(BUILD)
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef
