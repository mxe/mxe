# This file is part of MXE.
# See index.html for further information.

# WIDL is called "Wine IDL Compiler"; but we use mingw-w64's copy of it to
# avoid downloading Wine's entire tree.

PKG             := widl
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
    cd '$(1)/mingw-w64-tools/widl' && ./configure \
        --host='$(BUILD)' \
        --build='$(BUILD)' \
        --prefix='$(PREFIX)' \
        --target='$(TARGET)'
    $(MAKE) -C '$(1)/mingw-w64-tools/widl' -j '$(JOBS)' install
	
    # create cmake file
    echo 'set(CMAKE_WIDL $(PREFIX)/bin/$(TARGET)-$(PKG) CACHE PATH "widl executable")' \
    > '$(CMAKE_TOOLCHAIN_DIR)/$(PKG).cmake'
endef
