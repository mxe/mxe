# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# dbus
PKG             := dbus
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.1
$(PKG)_CHECKSUM := 112279ff58305027294fe0eb5bee600f68cf0b50
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://$(PKG).freedesktop.org/
$(PKG)_URL      := http://$(PKG).freedesktop.org/releases/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://cgit.freedesktop.org/dbus/dbus/refs/tags' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=[^0-9]*\\([0-9][^']*\\)'.*,\\1,p" | \
    grep -v '^1\.[0123]\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-xml=expat \
        --disable-tests \
        --disable-verbose-mode \
        --disable-asserts \
        --disable-shared \
        --enable-static \
        --disable-silent-rules
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
