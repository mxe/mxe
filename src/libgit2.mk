# This file is part of MXE.
# See index.html for further information.

PKG             := libgit2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.23.2
$(PKG)_CHECKSUM := 20c0a6ee92c0e19207dac6ddc336b4ae4a1c4ddf91be0891e4b6e6ccba16df0b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/libgit2/libgit2/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc libssh2

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DDLLTOOL='$(PREFIX)/bin/$(TARGET)-dlltool' \
        -DBUILD_SHARED_LIBS=$(if $(BUILD_STATIC),OFF,ON) \
        '$(1)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)' VERBOSE=1 || $(MAKE) -C '$(1).build' -j 1 VERBOSE=1
    $(MAKE) -C '$(1).build' -j 1 install VERBOSE=1
endef
