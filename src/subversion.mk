# This file is part of MXE.
# See index.html for further information.

PKG             := subversion
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.9.2
$(PKG)_CHECKSUM := 023da881139b4514647b6f8a830a244071034efcaad8c8e98c6b92393122b4eb
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://archive.apache.org/dist/subversion/$($(PKG)_FILE)
$(PKG)_URL_2    := http://mirror.23media.de/apache/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc apr apr-util sqlite openssl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://subversion.apache.org/download.cgi' | \
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
       '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-subversion.exe' \
       `'$(TARGET)-pkg-config' libsvn_client --cflags --libs` -lole32
endef

$(PKG)_BUILD_SHARED =
