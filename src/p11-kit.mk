# This file is part of MXE.
# See index.html for further information.

PKG             := p11-kit
$(PKG)_VERSION  := 0.23.2
$(PKG)_CHECKSUM := ba726ea8303c97467a33fca50ee79b7b35212964be808ecf9b145e9042fdfaf0
$(PKG)_SUBDIR   := p11-kit-$($(PKG)_VERSION)
$(PKG)_FILE     := p11-kit-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://p11-glue.freedesktop.org/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libtasn1

define $(PKG)_UPDATE
    echo 'TODO: write update script for $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
#        --disable-rpath \
        CPPFLAGS='-DWINVER=0x0600 \
        LIBS='-lws2_32' \
        ac_cv_prog_AR='$(TARGET)-ar'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
