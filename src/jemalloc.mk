PKG             := jemalloc
$(PKG)_WEBSITE  := github.com
$(PKG)_DESCR    := jemalloc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.3.0
$(PKG)_CHECKSUM := ef6f74fd45e95ee4ef7f9e19ebe5b075ca6b7fbe0140612b2a161abafb7ee179
$(PKG)_GH_CONF  := jemalloc/jemalloc/tags
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && autoconf
	cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
