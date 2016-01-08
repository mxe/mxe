# This file is part of MXE.
# See index.html for further information.

PKG                  := libiconv
$(PKG)_TARGETS       := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS_$(BUILD) :=

define $(PKG)_BUILD_$(BUILD)
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)' man1_MANS=
    $(MAKE) -C '$(1).build' -j 1 install man1_MANS=
endef
