# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libsoup
$(PKG)_WEBSITE  := https://github.com/GNOME/libsoup
$(PKG)_DESCR    := HTTP client/server library for GNOME
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.57.1
$(PKG)_APIVER   := 2.4
$(PKG)_CHECKSUM := 675c3bc11c2a6347625ca5215720d41c84fd8e9498dd664cda8a635fd5105a26
$(PKG)_GH_CONF  := GNOME/libsoup/tags,,,pre\|SOUP\|base
$(PKG)_DEPS     := cc glib libxml2 sqlite

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && \
        NOCONFIGURE=1 \
        ACLOCAL_FLAGS=-I'$(PREFIX)/$(TARGET)/share/aclocal' \
        ./autogen.sh
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)'/configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-vala \
        --without-apache-httpd \
        --without-gssapi \
        $(shell [ `uname -s` == Darwin ] && echo "INTLTOOL_PERL=/usr/bin/perl")
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    $(TARGET)-gcc \
        -W -Wall -Werror -ansi \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `$(TARGET)-pkg-config $(PKG)-$($(PKG)_APIVER) --cflags --libs`
endef
