# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# FreeTDS
PKG             := freetds
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.82
$(PKG)_CHECKSUM := 7e2a0c9e41c240c2d1c7f69c6f278e9a5bb80c2d
$(PKG)_SUBDIR   := freetds-$($(PKG)_VERSION)
$(PKG)_FILE     := freetds-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.freetds.org/
$(PKG)_URL      := http://ibiblio.org/pub/Linux/ALPHA/$(PKG)/stable/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv

define $(PKG)_UPDATE
    wget -q -O- 'http://freetds.cvs.sourceforge.net/viewvc/freetds/freetds/' | \
    grep '<option>R' | \
    $(SED) -n 's,.*R\([0-9][0-9_]*\)<.*,\1,p' | \
    $(SED) 's,_,.,g' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && NOCONFIGURE=true ./autogen.sh
    cd '$(1)' && $(LIBTOOLIZE)

    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) -i 's,cross_compiling=no,cross_compiling=yes,' '$(1)/configure'

    # beware --with-gnutls broken detection
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
        --with-tdsver=8.0
    cd '$(1)' && chmod +x doc/txt2man
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
