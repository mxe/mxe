# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pcre
$(PKG)_WEBSITE  := https://www.pcre.org/
$(PKG)_DESCR    := PCRE
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.44
$(PKG)_CHECKSUM := 19108658b23b3ec5058edc9f66ac545ea19f9537234be1ec62b714c84399366d
$(PKG)_SUBDIR   := pcre-$($(PKG)_VERSION)
$(PKG)_FILE     := pcre-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://ftp.pcre.org/pub/pcre/$($(PKG)_FILE)
$(PKG)_URL_2    := https://$(SOURCEFORGE_MIRROR)/project/pcre/pcre/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.pcre.org/pub/pcre/' | \
    $(SED) -n 's,.*pcre-\([0-9]\+\)\(\.[0-9]\+\)*\.zip.*,\1\2,p' | \
    tail -1
endef

define $(PKG)_BUILD_SHARED
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-pcre16 \
        --enable-utf \
        --enable-unicode-properties \
        --enable-cpp \
        --disable-pcregrep-libz \
        --disable-pcregrep-libbz2 \
        --disable-pcretest-libreadline
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_PROGRAMS) dist_html_DATA= dist_doc_DATA=
    rm -f '$(PREFIX)/$(TARGET)'/share/man/man1/pcre*.1
    rm -f '$(PREFIX)/$(TARGET)'/share/man/man3/pcre*.3
    ln -sf '$(PREFIX)/$(TARGET)/bin/pcre-config' '$(PREFIX)/bin/$(TARGET)-pcre-config'
endef

define $(PKG)_BUILD
    $(SED) -i 's,__declspec(dllimport),,' '$(1)/pcre.h.in'
    $(SED) -i 's,__declspec(dllimport),,' '$(1)/pcreposix.h'
    $($(PKG)_BUILD_SHARED)
endef
