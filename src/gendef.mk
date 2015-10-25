# This file is part of MXE.
# See index.html for further information.

PKG             := gendef
$(PKG)_IGNORE    = $(mingw-w64_IGNORE)
$(PKG)_VERSION   = $(mingw-w64_VERSION)
$(PKG)_CHECKSUM  = $(mingw-w64_CHECKSUM)
$(PKG)_SUBDIR    = $(mingw-w64_SUBDIR)
$(PKG)_FILE      = $(mingw-w64_FILE)
$(PKG)_URL       = $(mingw-w64_URL)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo $(mingw-w64_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)/mingw-w64-tools/gendef' && ./configure \
        --host='$(BUILD)' \
        --build='$(BUILD)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --target='$(TARGET)'
    $(MAKE) -C '$(1)/mingw-w64-tools/gendef' -j '$(JOBS)' install
endef
