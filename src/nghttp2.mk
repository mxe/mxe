# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := nghttp2
$(PKG)_WEBSITE  := https://nghttp2.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.62.1
$(PKG)_CHECKSUM := d0b0b9d00500ee4aa3bfcac00145d3b1ef372fd301c35bff96cf019c739db1b4
$(PKG)_FILE     := nghttp2-$($(PKG)_VERSION).tar.gz
$(PKG)_GH_CONF  := nghttp2/nghttp2/releases/tags,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-lib-only \
        --without-jemalloc \
        --without-libxml2
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_DOCS)
    $(if $(BUILD_STATIC),$(SED) -i 's/^\(Cflags:.* \)/\1 -DNGHTTP2_STATICLIB /g' '$(BUILD_DIR)/lib/libnghttp2.pc')
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_DOCS)
endef
