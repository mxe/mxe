# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := dbus
$(PKG)_WEBSITE  := https://dbus.freedesktop.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.13.16
$(PKG)_CHECKSUM := f56b0aa015d0cd13e235225484f411e3c587a0f852c12da03852a324dd1cafb3
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://$(PKG).freedesktop.org/releases/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc expat

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://cgit.freedesktop.org/dbus/dbus/refs/tags' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?h=dbus-\\([0-9][^']*\\)'.*,\\1,p" | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-tests \
        --disable-verbose-mode \
        --disable-asserts \
        --disable-maintainer-mode \
        --disable-silent-rules \
        --disable-launchd \
        --disable-doxygen-docs \
        --disable-xml-docs \
        CFLAGS='-DPROCESS_QUERY_LIMITED_INFORMATION=0x1000'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
