# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := wget2
$(PKG)_WEBSITE  := https://www.gnu.org/software/wget/
$(PKG)_VERSION  := 2.2.1
$(PKG)_CHECKSUM := f77397cce50b60670f48cfca5867517caed93f7c07ebea76541984d5d8d5c6d1
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.lz
$(PKG)_URL      := https://ftp.gnu.org/gnu/wget/$($(PKG)_FILE)
$(PKG)_DEPS     := cc brotli gnutls libidn2 libntlm libpsl pcre2 pthreads zstd

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.com/gnuwget/wget2/-/tags' | \
    $(SED) -n "s,.*<a [^>]\+>v\?\([0-9]\+\.[0-9.]\+\)<.*,\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-ssl=gnutls \
        CFLAGS='-DIN6_ARE_ADDR_EQUAL=IN6_ADDR_EQUAL $(if $(BUILD_STATIC),-DGNUTLS_INTERNAL_BUILD,)'\
        LDFLAGS='$(if $(BUILD_SHARED),-Wl$(comma)--allow-multiple-definition,)' \
        LIBS='-lbcrypt'
    $(MAKE) -C '$(BUILD_DIR)/lib' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)/libwget' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)/src' -j '$(JOBS)' install-binPROGRAMS
endef
