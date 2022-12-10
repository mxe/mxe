# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pcre2
$(PKG)_WEBSITE  := https://www.pcre.org/
$(PKG)_DESCR    := PCRE2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 10.41
$(PKG)_CHECKSUM := 0f78cebd3e28e346475fb92e95fe9999945b4cbaad5f3b42aca47b887fb53308
$(PKG)_GH_CONF  := PCRE2Project/pcre2/releases,pcre2-
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://github.com/PCRE2Project/pcre2/releases/download/pcre2-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_BUILD_SHARED
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-pcre2-16 \
        --enable-utf \
        --enable-unicode-properties \
        --enable-cpp \
        --disable-pcre2grep-libz \
        --disable-pcre2grep-libbz2 \
        --disable-pcre2test-libreadline
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_PROGRAMS) dist_html_DATA= dist_doc_DATA=
    rm -f '$(PREFIX)/$(TARGET)'/share/man/man1/pcre*.1
    rm -f '$(PREFIX)/$(TARGET)'/share/man/man3/pcre*.3
    ln -sf '$(PREFIX)/$(TARGET)/bin/pcre2-config' '$(PREFIX)/bin/$(TARGET)-pcre2-config'
endef

define $(PKG)_BUILD
    $(SED) -i 's,__declspec(dllimport),,' '$(1)/src/pcre2.h.in'
    $(SED) -i 's,__declspec(dllimport),,' '$(1)/src/pcre2posix.h'
    $(SED) -i 's,__declspec(dllimport),,' '$(1)/src/pcre2.h.generic'
    $($(PKG)_BUILD_SHARED)
endef
