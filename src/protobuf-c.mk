# This file is part of MXE.
# See index.html for further information.

PKG             := protobuf-c
$(PKG)_WEBSITE  := https://github.com/protobuf-c/protobuf-c
$(PKG)_DESCR    := Protocol Buffers implementation in C
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.1
$(PKG)_CHECKSUM := 99be336cdb15dfc5827efe34e5ac9aaa962e2485db547dd254d2a122a7d23102
$(PKG)_GH_CONF  := protobuf-c/protobuf-c/tags, v
$(PKG)_DEPS     := cc protobuf

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && autoreconf -fi
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS)

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT)

endef
