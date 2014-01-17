# This file is part of MXE.
# See index.html for further information.

PKG             := swig
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.11
$(PKG)_CHECKSUM := d3bf4e78824dba76bfb3269367f1ae0276b49df9
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$(PKG)-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc pcre

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/swig/files/swig/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./autogen.sh && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
	--enable-pcre \
	PKG_CONFIG='$(TARGET)-pkg-config' \
	LDFLAGS="`$(TARGET)-pkg-config --libs libpcre`"
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
    ln -sf "`which ccache`" '$(PREFIX)/bin/$(TARGET)'-ccache
endef

