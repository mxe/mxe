# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := nghttp2
$(PKG)_WEBSITE  := https://nghttp2.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.56.0
$(PKG)_CHECKSUM := eb00ded354db1159dcccabc11b0aaeac893b7c9b154f8187e4598c4b8f3446b5
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
