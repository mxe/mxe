# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := subversion
$(PKG)_WEBSITE  := https://subversion.apache.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.9.7
$(PKG)_CHECKSUM := c3b118333ce12e501d509e66bb0a47bcc34d053990acab45559431ac3e491623
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://archive.apache.org/dist/subversion/$($(PKG)_FILE)
$(PKG)_URL_2    := https://www.apache.org/dist/subversion/$($(PKG)_FILE)
$(PKG)_DEPS     := cc apr apr-util openssl sqlite

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://subversion.apache.org/download.cgi' | \
    $(SED) -n 's,.*#recommended-release">\([0-9][^<]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && PKG_CONFIG=$(PREFIX)/bin/$(TARGET)-pkg-config && ./autogen.sh && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-shared \
        --disable-mod-activation \
        --without-serf \
        --without-apr_memcache \
        --without-apxs \
        --without-jdk \
        --without-jikes \
        --without-swig \
        --with-sysroot=$(PREFIX)/$(TARGET) \
        --disable-javahl \
        --disable-nls \
        --without-gpg-agent \
        --with-gnome-keyring=no \
        PKG_CONFIG=$(PREFIX)/bin/$(TARGET)-pkg-config \
        --with-apr='$(PREFIX)/$(TARGET)' \
        --with-apr-util='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' \
        install-fsmod-lib install-ramod-lib install-lib install-include \
        LDFLAGS="-lversion -lole32 -luuid -no-undefined" \
        pkgconfig_dir="$(PREFIX)/$(TARGET)/lib/pkgconfig" \
        install
    '$(TARGET)-gcc' \
       -mwindows -W -Wall -Werror -pedantic \
       '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-subversion.exe' \
       `'$(TARGET)-pkg-config' libsvn_client --cflags --libs` -lole32
endef

$(PKG)_BUILD_SHARED =
