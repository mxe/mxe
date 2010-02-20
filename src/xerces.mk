# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# Xerces-C++
PKG             := xerces
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.0
$(PKG)_CHECKSUM := 15e45ae354980d6aa58e8c14eb6bc9fd84e51929
$(PKG)_SUBDIR   := xerces-c-$($(PKG)_VERSION)
$(PKG)_FILE     := xerces-c-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://xerces.apache.org/xerces-c/
$(PKG)_URL      := http://apache.linux-mirror.org/xerces/c/$(word 1,$(subst ., ,$($(PKG)_VERSION)))/sources/$($(PKG)_FILE)
$(PKG)_URL_2    := http://www.apache.org/dist/xerces/c/$(word 1,$(subst ., ,$($(PKG)_VERSION)))/sources/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv curl

define $(PKG)_UPDATE
    wget -q -O- 'http://svn.apache.org/viewvc/xerces/c/tags/?sortby=date' | \
    grep '<a name="' | \
    $(SED) -n 's,.*<a name="Xerces-C_\([0-9][^"]*\)".*,\1,p' | \
    $(SED) 's,_,.,g' | \
    grep -v rc | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && $(SHELL) ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-libtool-lock \
        --disable-pretty-make \
        --enable-threads \
        --enable-network \
        --enable-netaccessor-curl \
        --disable-netaccessor-socket \
        --disable-netaccessor-cfurl \
        --disable-netaccessor-winsock \
        --enable-transcoder-iconv \
        --disable-transcoder-gnuiconv \
        --disable-transcoder-icu \
        --disable-transcoder-macosunicodeconverter \
        --disable-transcoder-windows \
        --enable-msgloader-inmemory \
        --disable-msgloader-iconv \
        --disable-msgloader-icu \
        --with-curl='$(PREFIX)/$(TARGET)' \
        --without-icu \
        LIBS="`$(TARGET)-pkg-config --libs libcurl`"
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
