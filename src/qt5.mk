# This file is part of MXE.
# See index.html for further information.

PKG             := qt5
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_UPDATE    = echo $(qtbase_VERSION)
$(PKG)_DEPS     := $(patsubst $(TOP_DIR)/src/%.mk,%,\
                        $(shell grep -l 'DEPS.*qtbase' \
                                $(TOP_DIR)/src/qt*.mk \
                                --exclude '$(TOP_DIR)/src/qt5.mk'))
