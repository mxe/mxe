# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libgit2
$(PKG)_WEBSITE  := https://libgit2.github.com/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.28.1
$(PKG)_CHECKSUM := 0ca11048795b0d6338f2e57717370208c2c97ad66c6d5eac0c97a8827d13936b
$(PKG)_GH_CONF  := libgit2/libgit2/releases/latest,v
$(PKG)_DEPS     := cc libssh2

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DDLLTOOL='$(PREFIX)/bin/$(TARGET)-dlltool'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1 || $(MAKE) -C '$(BUILD_DIR)' -j 1 VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1
endef
