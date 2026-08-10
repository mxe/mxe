# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := lame
$(PKG)_WEBSITE  := https://lame.sourceforge.io/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.0
$(PKG)_CHECKSUM := 3df5124d5ad3a98312ffd7ba6a9b36230e4f8a3e66d3ce0f425e336c32d216eb
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
# $(BUILD)~gettext only required for autoreconf *.m4 macros
$(PKG)_DEPS     := cc $(BUILD)~gettext mpg123

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/p/lame/svn/HEAD/tree/tags' | \
    grep RELEASE_ | \
    $(SED) -n 's,.*RELEASE__\([0-9_][^<]*\)<.*,\1,p' | \
    tr '_' '.' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --disable-frontend \
        --disable-gtktest \
        CFLAGS='-Wno-incompatible-pointer-types'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
