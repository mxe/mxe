# This file is part of MXE.
# See index.html for further information.

PKG             := tlspool
$(PKG)_VERSION  := 0.11
$(PKG)_CHECKSUM := 8decc8c9c459c901fe718eecb38107a958d491c93c7673315eef2a17b4083813
$(PKG)_SUBDIR   := $(PKG)-$(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/hfmanson/$(PKG)/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc pthreads gnutls p11-kit libtasn1 db quick-der

define $(PKG)_UPDATE
    echo 'TODO: write update script for $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

$(PKG)_MAKE_OPTS = \
        PREFIX='$(PREFIX)/$(TARGET)' \
        CROSS_SUFFIX='$(TARGET)-' \
        CC='$(TARGET)-gcc' \
		PKG_CONFIG='$(TARGET)-pkg-config' \
		DLLTOOL='$(TARGET)-dlltool' \
        HOSTCC='$(BUILD_CC)' \
        WINVER=0x0600 \
		SBIN=bin

define $(PKG)_BUILD
    $(MAKE)  -C '$(1)/src' -j '$(JOBS)' install $($(PKG)_MAKE_OPTS)
    $(MAKE)  -C '$(1)/lib' -j '$(JOBS)' install $($(PKG)_MAKE_OPTS)
endef
