# This file is part of MXE.
# See index.html for further information.

PKG             := unbound
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.5.10_20160712
$(PKG)_CHECKSUM := 50b8ea88b88d6db899fcb43cd35497791b729fee5d6690b6205f89497c0575e1
$(PKG)_SUBDIR   := unbound-$($(PKG)_VERSION)
$(PKG)_FILE     := unbound-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.nlnetlabs.nl/~wouter/$($(PKG)_FILE)
# $(PKG)_URL_2    := .../$($(PKG)_FILE)
$(PKG)_DEPS     := gcc openssl zlib expat



define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://unbound.net/downloads/' | \
    grep 'unbound-[0-9]' | \
    $(SED) -n 's,.*unbound-\([0-9][^>]*\)\.tar\.gz.*,\1,p' | \
    grep -v 'rc[0-9]' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
		$(MXE_CONFIGURE_OPTS) \
		--disable-flto \
		--enable-shared \
		--without-pthreads \
		--with-libexpat=$(PREFIX)/$(TARGET) \
		--with-conf_file="'C:\Program Files (x86)\Unbound\service.conf'" \
		LIBS="`'$(TARGET)-pkg-config' openssl --libs`"
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef

