# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := poppler-qt5
$(PKG)_WEBSITE   = $(poppler_WEBSITE)
$(PKG)_IGNORE    = $(poppler_IGNORE)
$(PKG)_VERSION   = $(poppler_VERSION)
$(PKG)_CHECKSUM  = $(poppler_CHECKSUM)
$(PKG)_SUBDIR    = $(poppler_SUBDIR)
$(PKG)_FILE      = $(poppler_FILE)
$(PKG)_URL       = $(poppler_URL)
$(PKG)_DEPS     := cc poppler qtbase

define $(PKG)_BUILD
    $(subst @build_with_cpp@,OFF, \
    $(subst @build_with_glib@,OFF, \
    $(subst @build_with_qt5@,ON, \
    $(subst @build_with_qt6@,OFF, \
    $(poppler_BUILD_COMMON)))))

    $(MAKE) -C '$(BUILD_DIR)/qt5' -j 1 install
    $(INSTALL) '$(BUILD_DIR)/poppler-qt5.pc' '$(PREFIX)/$(TARGET)/lib/pkgconfig/poppler-qt5.pc'
endef

