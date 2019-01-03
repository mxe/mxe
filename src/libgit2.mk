# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libgit2
$(PKG)_WEBSITE  := https://libgit2.github.com/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.27.7
$(PKG)_CHECKSUM := 1a5435a483759b1cd96feb12b11abb5231b0688016db506ce5947178f6ba2531
$(PKG)_GH_CONF  := libgit2/libgit2/releases/latest,v
$(PKG)_DEPS     := cc libssh2

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DDLLTOOL='$(PREFIX)/bin/$(TARGET)-dlltool'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1 || $(MAKE) -C '$(BUILD_DIR)' -j 1 VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1
endef
