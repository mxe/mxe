# This file is part of MXE.
# See index.html for further information.

PKG             := plib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.5-rc1
$(PKG)_CHECKSUM := d421a3c84517b4bfc8c6402887c74984ec57c12bc85f2dc2729de3ec4cdcdbe4
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- "http://sourceforge.net/projects/plib/files/plib/" | \
    grep 'plib/files/plib' | \
    $(SED) -n 's,.*plib/\([0-9][^>]*\)/.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        PKG_CONFIG='$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install \
        bin_PROGRAMS= \
        sbin_PROGRAMS= \
        noinst_PROGRAMS= \
        html_DATA= \
        LDFLAGS=-no-undefined
        AR='$(TARGET)-ar'
endef
