# This file is part of MXE.
# See index.html for further information.

PKG             := speexdsp
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2rc3
$(PKG)_CHECKSUM := 4ae688600039f5d224bdf2e222d2fbde65608447e4c2f681585e4dca6df692f1
$(PKG)_SUBDIR   := speexdsp-$($(PKG)_VERSION)
$(PKG)_FILE     := speexdsp-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://downloads.xiph.org/releases/speex/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.xiph.org/?p=speexdsp.git;a=tags' | \
    grep '<a class="list name"' | \
    $(SED) -n 's,.*<a[^>]*>SpeexDSP-\([0-9][^<]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS= doc_DATA=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS= doc_DATA=
endef
