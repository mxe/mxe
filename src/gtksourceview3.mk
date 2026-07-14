# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gtksourceview3
$(PKG)_WEBSITE  := https://projects.gnome.org/gtksourceview/
$(PKG)_DESCR    := GTKSourceView
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.24.11
$(PKG)_CHECKSUM := 691b074a37b2a307f7f48edc5b8c7afa7301709be56378ccf9cc9735909077fd
$(PKG)_SUBDIR   := gtksourceview-$($(PKG)_VERSION)
$(PKG)_FILE     := gtksourceview-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/gtksourceview/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gtk3 libxml2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/gtksourceview/tags?&search=GTKSOURCEVIEW_3' | \
    $(SED) -n "s,.*<a [^>]\+>GTKSOURCEVIEW_\(3_[0-9_]\+\)<.*,\1,p" | \
    $(SED) "s,_,.,g;" | \
    grep -v '^3\.9[0-9]\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT)
endef
