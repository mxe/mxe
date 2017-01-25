# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := liblastfm_qt4
$(PKG)_WEBSITE   = $(liblastfm_WEBSITE)
$(PKG)_DESCR     = $(liblastfm_DESCR)
$(PKG)_IGNORE    = $(liblastfm_IGNORE)
$(PKG)_VERSION   = $(liblastfm_VERSION)
$(PKG)_CHECKSUM  = $(liblastfm_CHECKSUM)
$(PKG)_SUBDIR    = $(liblastfm_SUBDIR)
$(PKG)_FILE      = $(liblastfm_FILE)
$(PKG)_URL       = $(liblastfm_URL)
$(PKG)_PATCHES   = $(realpath $(sort $(wildcard $(addsuffix /liblastfm-[0-9]*.patch, $(TOP_DIR)/src))))
$(PKG)_DEPS     := gcc fftw libsamplerate qt

define $(PKG)_UPDATE
    echo $(liblastfm_VERSION)
endef

$(PKG)_BUILD = $(subst @lastfm_use_qt4@,ON, \
               $(subst @lastfm_version_suffix@,, \
               $(liblastfm_BUILD_COMMON)))

$(PKG)_BUILD_STATIC =
