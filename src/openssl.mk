# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# openssl
PKG             := openssl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.9.8l
$(PKG)_CHECKSUM := d3fb6ec89532ab40646b65af179bb1770f7ca28f
$(PKG)_SUBDIR   := openssl-$($(PKG)_VERSION)
$(PKG)_FILE     := openssl-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.openssl.org/
$(PKG)_URL      := http://www.openssl.org/source/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.openssl.org/source/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib libgcrypt

define $(PKG)_UPDATE
    wget -q -O- 'http://www.openssl.org/source/' | \
    grep '<a href="openssl-' | \
    $(SED) -n 's,.*openssl-\([0-9][0-9a-z.]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # workarounds according to
    # http://wagner.pp.ru/~vitus/articles/openssl-mingw.html
    $(SED) -i 's,^$$IsMK1MF=1.*,,' '$(1)'/Configure
    $(SED) -i 's,static type _hide_##name,type _hide_##name,' '$(1)'/e_os2.h

    # use winsock2 instead of winsock
    $(SED) -i 's,wsock32,ws2_32,g' '$(1)'/Configure
    find '$(1)' -type f -exec \
        $(SED) -i 's,winsock\.h,winsock2.h,g' {} \;

    cd '$(1)' && CC='$(TARGET)-gcc' ./Configure \
        mingw \
        zlib \
        no-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' install -j 1 \
        CC='$(TARGET)-gcc' \
        RANLIB='$(TARGET)-ranlib' \
        AR='$(TARGET)-ar rcu'
endef
