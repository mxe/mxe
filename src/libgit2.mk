# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libgit2
$(PKG)_WEBSITE  := https://libgit2.github.com/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.9.7
$(PKG)_CHECKSUM := 1a4fbe7589e814777ae76b64734ad80f4ecad22cd33a22682a2aaea4ae5375e7
$(PKG)_GH_CONF  := libgit2/libgit2/releases/latest,v
$(PKG)_DEPS     := cc libssh2 pcre2 zlib

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DDLLTOOL='$(PREFIX)/bin/$(TARGET)-dlltool' \
        -DUSE_SSH=ON \
        -DREGEX_BACKEND=pcre2
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1 || $(MAKE) -C '$(BUILD_DIR)' -j 1 VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1
endef
