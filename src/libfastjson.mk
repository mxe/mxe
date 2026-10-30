# This file is part of MXE.
# See index.html for further information.

PKG             := libfastjson
$(PKG)_WEBSITE  := https://github.com/rsyslog/libfastjson
$(PKG)_DESCR    := Fast JSON Library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.99.9
$(PKG)_CHECKSUM := 881f954633aa76931e4c756ece0bda6fd8a673c6e66955a3db3b2bb9d6bbff72
$(PKG)_GH_CONF  := rsyslog/libfastjson/tags, v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && autoreconf -fi
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS)

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT)

endef
