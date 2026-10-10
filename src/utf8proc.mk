# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := utf8proc
$(PKG)_WEBSITE  := https://github.com/JuliaStrings/utf8proc
$(PKG)_DESCR    := utf8proc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.12.0
$(PKG)_CHECKSUM := f564011d38b2888d583d510b08e69ffa15aa117155db1b9b49ef1dfe1fa25111
$(PKG)_GH_CONF  := juliastrings/utf8proc/tags,v
$(PKG)_DEPS     := cc cmake-conf

define $(PKG)_BUILD
    '$(TARGET)-cmake' -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        $(PKG_CMAKE_OPTS)
    '$(TARGET)-cmake' --build '$(BUILD_DIR)' --parallel '$(JOBS)'
    '$(TARGET)-cmake' --install '$(BUILD_DIR)'
endef
