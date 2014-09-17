# This file is part of MXE.
# See index.html for further information.

PKG             := dbus
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.8
$(PKG)_CHECKSUM := e0d10e8b4494383c7e366ac80a942ba45a705a96
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(PKG).freedesktop.org/releases/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc expat

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://cgit.freedesktop.org/dbus/dbus/refs/tags' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=dbus-\\([0-9][^']*\\)'.*,\\1,p" | \
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
