# mxe/src/libcddb.mk
# This file is part of MXE.
# See index.html for further information.

PKG             := libcddb
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 1.3.2
$(PKG)_CHECKSUM := 35ce0ee1741ea38def304ddfe84a958901413aa829698357f0bee5bb8f0a223b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://downloads.sourceforge.net/project/libcddb/libcddb/$($(PKG)_VERSION)/$(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://downloads.sourceforge.net/project/libcddb/libcddb/' | \
    $(SED) -n 's,.*libcddb-\([0-9][^>]*\)\.tar.*,\1,p' | \
    sort | uniq | \
    head -1
endef

# lt_cv_deplibs_check_method="pass_all"		allow all libs (avoid static lib creation for x64 because of ws2_32.lib)
# ac_cv_func_malloc_0_nonnull=yes		avoid unresolved external
# ac_cv_func_realloc_0_nonnull=yes		avoid unresolved external
define $(PKG)_BUILD
    cd '$(1)' && \
	lt_cv_deplibs_check_method="pass_all" \
    	ac_cv_func_malloc_0_nonnull=yes \
    	ac_cv_func_realloc_0_nonnull=yes \
    	LDFLAGS="-L$(PREFIX)/$(TARGET)/lib/ -L$(PREFIX)/$(TARGET)/bin/" \
    	CPPFLAGS="-I$(PREFIX)/$(TARGET)/include/" \
    	./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

$(PKG)_BUILD_i686-pc-mingw32    = $(subst @special-target@, x86-win32-gcc,    $($(PKG)_BUILD))
$(PKG)_BUILD_i686-w64-mingw32   = $(subst @special-target@, x86-win32-gcc,    $($(PKG)_BUILD))
$(PKG)_BUILD_x86_64-w64-mingw32 = $(subst @special-target@, x86_64-win64-gcc, $($(PKG)_BUILD))

