# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# PCRE
PKG             := pcre
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.21
$(PKG)_CHECKSUM := 52abf655d94f5208377258ffff27c7b35c53af39
$(PKG)_SUBDIR   := pcre-$($(PKG)_VERSION)
$(PKG)_FILE     := pcre-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.pcre.org/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/pcre/pcre/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/pcre/files/pcre/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,__declspec(dllimport),,' '$(1)/pcre.h.in'
    $(SED) -i 's,__declspec(dllimport),,' '$(1)/pcreposix.h'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-utf8 \
        --enable-unicode-properties \
        --disable-cpp \
        --disable-pcregrep-libz \
        --disable-pcregrep-libbz2 \
        --disable-pcretest-libreadline
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
