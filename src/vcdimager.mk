# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := vcdimager
$(PKG)_WEBSITE  := https://www.gnu.org/software/vcdimager/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.1
$(PKG)_CHECKSUM := 67515fefb9829d054beae40f3e840309be60cda7d68753cafdd526727758f67a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/vcdimager/$(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc libcdio libxml2 popt

define $(PKG)_UPDATE
    $(call GET_LATEST_VERSION, https://ftp.gnu.org/gnu/vcdimager)
endef

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_PROGRAMS) $(if $(BUILD_SHARED),LDFLAGS=-no-undefined)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_PROGRAMS)
endef
