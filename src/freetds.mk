# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# FreeTDS
PKG             := freetds
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.91rc
$(PKG)_CHECKSUM := fa6b50badf287fc8d853285d4d6fc6544fe76c6a
$(PKG)_SUBDIR   := freetds-0.91.dev.20110415RC2
$(PKG)_FILE     := freetds-$($(PKG)_VERSION).tgz
$(PKG)_WEBSITE  := http://www.freetds.org/
$(PKG)_URL      := http://www.ibiblio.org/pub/Linux/ALPHA/$(PKG)/stable/$($(PKG)_FILE)
$(PKG)_URL_2    := http://ftp.debian.org/debian/pool/main/f/$(PKG)/$(PKG)_$($(PKG)_VERSION).orig.tar.gz
$(PKG)_DEPS     := gcc libiconv gnutls

define $(PKG)_UPDATE
    wget -q -O- 'http://freetds.cvs.sourceforge.net/viewvc/freetds/freetds/' | \
    grep '<option>R' | \
    $(SED) -n 's,.*R\([0-9][0-9_]*\)<.*,\1,p' | \
    $(SED) 's,_,.,g' | \
    head -1
endef

define $(PKG)_BUILD
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) -i 's,cross_compiling=no,cross_compiling=yes,' '$(1)/configure'

    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --disable-rpath \
        --disable-dependency-tracking \
        --disable-shared \
        --enable-static \
        --enable-libiconv \
        --enable-msdblib \
        --enable-sspi \
        --disable-threadsafe \
        --with-tdsver=7.2 \
        --with-gnutls \
        PKG_CONFIG='$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install man_MANS=
endef
