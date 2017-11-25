# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libgit2
$(PKG)_WEBSITE  := https://libgit2.github.com/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.23.2
$(PKG)_CHECKSUM := 6cff6c84d30138358069d29ccf6f3e79c06438a3fda7274d5b1fe14c37f82f08
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/libgit2/libgit2/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc libssh2

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && '$(TARGET)-cmake' \
        -DDLLTOOL='$(PREFIX)/bin/$(TARGET)-dlltool' \
        '$(1)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)' VERBOSE=1 || $(MAKE) -C '$(1).build' -j 1 VERBOSE=1
    $(MAKE) -C '$(1).build' -j 1 install VERBOSE=1
endef
