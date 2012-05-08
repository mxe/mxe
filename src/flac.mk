# This file is part of MXE.
# See index.html for further information.

PKG             := flac
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := bd54354900181b59db3089347cc84ad81e410b38
$(PKG)_SUBDIR   := flac-$($(PKG)_VERSION)
$(PKG)_FILE     := flac-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/flac/flac-src/flac-$($(PKG)_VERSION)-src/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv ogg

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://flac.cvs.sourceforge.net/viewvc/flac/flac/' | \
    grep '<option>FLAC_RELEASE_' | \
    $(SED) -n 's,.*FLAC_RELEASE_\([0-9][0-9_]*\)__.*,\1,p' | \
    $(SED) 's,_,.,g' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-doxygen-docs \
        --disable-xmms-plugin \
        --enable-cpplibs \
        --enable-ogg \
        --disable-oggtest
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
