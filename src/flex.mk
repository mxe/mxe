# This file is part of MXE.
# See index.html for further information.

PKG             := flex
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5.39
$(PKG)_CHECKSUM := 267794c709d5c50f2dcb48ff5d8dcbbfe40f953e
$(PKG)_SUBDIR   := flex-$($(PKG)_VERSION)
$(PKG)_FILE     := flex-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/flex/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/flex/files/' | \
    grep -i 'flex/files/' | \
    $(SED) -n 's,.*/flex-\([0-9\.]*\)\.tar.*/.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD_$(BUILD)
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef
