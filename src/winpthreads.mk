# This file is part of MXE.
# See index.html for further information.

PKG             := winpthreads
$(PKG)_IGNORE    = $(mingw-w64_IGNORE)
$(PKG)_VERSION   = $(mingw-w64_VERSION)
$(PKG)_CHECKSUM  = $(mingw-w64_CHECKSUM)
$(PKG)_SUBDIR    = $(mingw-w64_SUBDIR)
$(PKG)_FILE      = $(mingw-w64_FILE)
$(PKG)_URL       = $(mingw-w64_URL)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo $(mingw-w64_VERSION)
endef

define $(PKG)_BUILD_mingw-w64
    cd '$(1)/mingw-w64-libraries/winpthreads' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)/mingw-w64-libraries/winpthreads' -j '$(JOBS)' install

    $(PTHREADS_TEST)
endef

$(PKG)_BUILD_x86_64-w64-mingw32 = $($(PKG)_BUILD_mingw-w64)
$(PKG)_BUILD_i686-w64-mingw32   = $($(PKG)_BUILD_mingw-w64)
