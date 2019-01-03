# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := winpthreads-host
$(PKG)_IGNORE    = $(mingw-w64_IGNORE)
$(PKG)_VERSION   = $(mingw-w64_VERSION)
$(PKG)_CHECKSUM  = $(mingw-w64_CHECKSUM)
$(PKG)_SUBDIR    = $(mingw-w64_SUBDIR)
$(PKG)_FILE      = $(mingw-w64_FILE)
$(PKG)_PATCHES   = $(mingw-w64_PATCHES)
$(PKG)_URL       = $(mingw-w64_URL)
$(PKG)_URL_2     = $(mingw-w64_URL_2)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    echo $(mingw-w64_VERSION)
endef

# temporary build until gcc is built only once per arch
define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/mingw-w64-libraries/winpthreads/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --enable-static \
        --enable-shared
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
