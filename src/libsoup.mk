# This file is part of MXE.
# See index.html for further information.

PKG             := libsoup
$(PKG)_IGNORE   := libsoup-pre%
$(PKG)_VERSION  := 2.54.0.1
$(PKG)_APIVER   := 2.4
$(PKG)_CHECKSUM := b466c68e6575ca5ed170da60cc316c562a96db5dba5345a6043f740201afa8f4
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/GNOME/$(PKG)/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc glib libxml2 sqlite

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, GNOME/libsoup)
endef

define $(PKG)_BUILD
    cd '$(1)' && \
        NOCONFIGURE=1 \
        ACLOCAL_FLAGS=-I'$(PREFIX)/$(TARGET)/share/aclocal' \
        ./autogen.sh
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-vala \
        --without-gssapi
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install

    $(TARGET)-gcc \
        -W -Wall -Werror -ansi \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `$(TARGET)-pkg-config $(PKG)-$($(PKG)_APIVER) --cflags --libs`
endef
