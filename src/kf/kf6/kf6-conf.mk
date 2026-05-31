# This file is part of MXE. See LICENSE.md for licensing information.

include src/qt/qt6/qt6-qtbase.mk

PKG             := kf6-conf
$(PKG)_VERSION  := 6.26.0
$(PKG)_DEPS     := qt6-qtbase
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)

define KF6_METADATA
    $(PKG)_WEBSITE  := https://kde.org/
    $(PKG)_DESCR    := KDE Frameworks 6
    $(PKG)_IGNORE    :=
    $(PKG)_VERSION  := $(kf6-conf_VERSION)
    $(PKG)_SUBDIR   := $(subst kf6-,,$(PKG))-$(kf6-conf_VERSION)
    $(PKG)_FILE     := $(subst kf6-,,$(PKG))-$(kf6-conf_VERSION).tar.xz
    $(PKG)_URL      := https://download.kde.org/stable/frameworks/$(call SHORT_PKG_VERSION,kf6-conf)/$(subst kf6-,,$(PKG))-$(kf6-conf_VERSION).tar.xz
    $(PKG)_UPDATE   := echo $(kf6-conf_VERSION)
endef

KF6_CMAKE = $(QT6_QT_CMAKE) \
    -DBUILD_TESTING=OFF \
    -DBUILD_PYTHON_BINDINGS=OFF \
    -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
    -DKDE_INSTALL_LIBDIR=lib \
    -DKDE_INSTALL_LIBEXECDIR=libexec \
    -DKF6_HOST_TOOLING='$(PREFIX)/$(BUILD)/$(MXE_QT6_ID);$(PREFIX)/$(BUILD)/$(MXE_QT6_ID)/bin;$(PREFIX)/$(BUILD)/$(MXE_QT6_ID)/lib/cmake'

define $(PKG)_BUILD
    # kf6-conf is a configuration package, no build needed
endef
