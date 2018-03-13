# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := miniupnpc
$(PKG)_WEBSITE  := http://miniupnp.free.fr/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0
$(PKG)_CHECKSUM := 253a0ea5fe8f17d9f79f8758e1b6415d6a560e58bf3e9b5dbe714413dc908446
$(PKG)_GH_CONF  := miniupnp/miniupnp/tags,miniupnpc_,,,_
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)/miniupnpc' \
        -DUPNPC_BUILD_STATIC=$(CMAKE_STATIC_BOOL) \
        -DUPNPC_BUILD_SHARED=$(CMAKE_SHARED_BOOL) \
        -DUPNPC_BUILD_TESTS=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
