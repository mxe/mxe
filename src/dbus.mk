# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# dbus
PKG             := dbus
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.5.4
$(PKG)_CHECKSUM := 11bd5828ac56a3e8f125a487b5743f09914ecea6
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://$(PKG).freedesktop.org/
$(PKG)_URL      := http://$(PKG).freedesktop.org/releases/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc expat

define $(PKG)_UPDATE
    wget -q -O- 'http://cgit.freedesktop.org/dbus/dbus/refs/tags' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=[^0-9]*\\([0-9][^']*\\)'.*,\\1,p" | \
    grep -v '^1\.[01234]\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && automake && ./configure \
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
