# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtsparkle_qt4
$(PKG)_WEBSITE   = $(qtsparkle_WEBSITE)
$(PKG)_DESCR     = $(qtsparkle_DESCR)
$(PKG)_IGNORE    = $(qtsparkle_IGNORE)
$(PKG)_VERSION   = $(qtsparkle_VERSION)
$(PKG)_CHECKSUM  = $(qtsparkle_CHECKSUM)
$(PKG)_SUBDIR    = $(qtsparkle_SUBDIR)
$(PKG)_FILE      = $(qtsparkle_FILE)
$(PKG)_URL       = $(qtsparkle_URL)
$(PKG)_PATCHES   = $(realpath $(sort $(wildcard $(addsuffix /qtsparkle-[0-9]*.patch, $(TOP_DIR)/src))))
$(PKG)_DEPS     := cc qt

define $(PKG)_UPDATE
    echo $(qtsparkle_VERSION)
endef

$(PKG)_BUILD = $(subst @qtsparkle_use_qt4@,ON, \
               $(subst @qtsparkle_version_suffix@,, \
               $(subst @qtsparkle_pc_requires@,QtCore QtGui QtNetwork QtXml, \
               $(qtsparkle_BUILD_COMMON))))
