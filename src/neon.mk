# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := neon
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 0.30.2
$(PKG)_CHECKSUM := db0bd8cdec329b48f53a6f00199c92d5ba40b0f015b153718d1b15d3d967fbca
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://webdav.org/$(PKG)/$(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc openssl expat

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://webdav.org/$(PKG)/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/"\.tar.*,\1,p' | \
    sort | uniq | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && \
        ne_cv_fmt_size_t=%lu \
        ne_cv_fmt_ssize_t=%lu \
        ne_cv_fmt_off64_t=%I64u \
        ne_cv_fmt_time_t=%lu \
        ne_cv_libsfor_socket=-lws2_32 \
        ne_cv_libsfor_gethostbyname=-lws2_32 \
    	'$(SOURCE_DIR)'/configure \
        $(MXE_CONFIGURE_OPTS) \
        $(MXE_DISABLE_DOCS) \
	--with-ssl=yes 
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'                                                                                          
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install-lib install-headers install-nls                                                                                          
endef

$(PKG)_BUILD_i686-pc-mingw32    = $(subst @special-target@, x86-win32-gcc,    $($(PKG)_BUILD))
$(PKG)_BUILD_i686-w64-mingw32   = $(subst @special-target@, x86-win32-gcc,    $($(PKG)_BUILD))
$(PKG)_BUILD_x86_64-w64-mingw32 = $(subst @special-target@, x86_64-win64-gcc, $($(PKG)_BUILD))

