# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := arpa2cm
$(PKG)_WEBSITE  := https://github.com/arpa2/arpa2cm
$(PKG)_DESCR    := CMake Module library for the ARPA2 project
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := aac2433
$(PKG)_CHECKSUM := e259059f08c0bdb41cc21eb2f4ee29c3316a817a325853bf25810810935b311a
$(PKG)_GH_CONF  := arpa2/arpa2cm/master
$(PKG)_DEPS     :=
$(PKG)_TARGETS  := $(BUILD)
# needed for quick-der

$(PKG)_DEPS_$(BUILD) := cmake

define $(PKG)_BUILD
    # install cmake modules
    cd '$(BUILD_DIR)' && cmake '$(SOURCE_DIR)' \
        -DCMAKE_INSTALL_PREFIX='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
