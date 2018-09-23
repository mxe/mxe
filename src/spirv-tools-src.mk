# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := spirv-tools-src
$(PKG)_WEBSITE  := https://github.com/KhronosGroup/SPIRV-Tools
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2018.5
$(PKG)_SUBDIR   := SPIRV-Tools-$($(PKG)_VERSION)
$(PKG)_CHECKSUM := bc56f1b53827811095aad330e078604f06319c4b0648a4bbe183a4bfe5b3ef58
$(PKG)_GH_CONF  := KhronosGroup/SPIRV-Tools/tags,v
$(PKG)_TYPE     := source-only
