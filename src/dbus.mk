# This file is part of MXE.
# See index.html for further information.

PKG             := dbus
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 676ba5211d85f5273ff5748e72e3b48b5104e7ea
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(PKG).freedesktop.org/releases/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc expat

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://cgit.freedesktop.org/dbus/dbus/refs/tags' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=[^0-9]*\\([0-9][^']*\\)'.*,\\1,p" | \
    grep -v '^1\.[01234]\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-xml=expat \
        --disable-tests \
        --disable-verbose-mode \
        --disable-asserts \
        --disable-shared \
        --disable-maintainer-mode \
        --enable-static \
        --disable-silent-rules
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
