# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libcddb
$(PKG)_WEBSITE  := https://sourceforge.net/projects/libcddb/
$(PKG)_DESCR    := Access data on a CDDB
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.2
$(PKG)_CHECKSUM := 35ce0ee1741ea38def304ddfe84a958901413aa829698357f0bee5bb8f0a223b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/libcddb/libcddb/$($(PKG)_VERSION)/$(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_DEPS     := cc libgnurx libiconv

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://downloads.sourceforge.net/project/libcddb/libcddb/' | \
    $(SED) -n 's,.*libcddb-\([0-9][^>]*\)\.tar.*,\1,p' | \
    sort | uniq | \
    head -1
endef

# lt_cv_deplibs_check_method="pass_all"        allow all libs (avoid static lib creation for x64 because of ws2_32.lib)
# ac_cv_func_malloc_0_nonnull=yes        avoid unresolved external
# ac_cv_func_realloc_0_nonnull=yes        avoid unresolved external
define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && \
        lt_cv_deplibs_check_method="pass_all" \
        ac_cv_func_malloc_0_nonnull=yes \
        ac_cv_func_realloc_0_nonnull=yes \
        '$(SOURCE_DIR)'/configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_PROGRAMS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_PROGRAMS)

    # create test binary
    $(TARGET)-gcc \
        -W -Wall -Werror \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `$(TARGET)-pkg-config libcddb --cflags --libs`
endef
