# This file is part of MXE.
# See index.html for further information.

PKG             := intltool
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.50.2
$(PKG)_CHECKSUM := 7fddbd8e1bf94adbf1bc947cbf3b8ddc2453f8ad
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://launchpad.net/$(PKG)/trunk/$($(PKG)_VERSION)/+download/$(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package intltool.' >&2;
    echo $(intltool_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(1)/configure' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --enable-static

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
