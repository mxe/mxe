# This file is part of MXE. See LICENSE.md for licensing information.

PKG := qtkeychain-qt6
$(PKG)_WEBSITE  = $(qtkeychain_WEBSITE)
$(PKG)_DESCR    = $(qtkeychain_DESCR)
$(PKG)_IGNORE   = $(qtkeychain_IGNORE)
$(PKG)_VERSION  = $(qtkeychain_VERSION)
$(PKG)_CHECKSUM = $(qtkeychain_CHECKSUM)
$(PKG)_GH_CONF  = $(qtkeychain_GH_CONF)
$(PKG)_DEPS     = cc qt6-qttools

$(PKG)_BUILD = $(subst @build_with_qt6@,on, \
               $(subst @qt_version_prefix@,qt6, \
               $(subst @qtcore_pkgconfig_module@,Qt6Core, \
               $(qtkeychain_BUILD_COMMON))))
