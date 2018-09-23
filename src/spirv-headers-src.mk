# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := spirv-headers-src
$(PKG)_WEBSITE  := https://github.com/KhronosGroup/SPIRV-Headers
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := d5b2e12
$(PKG)_SUBDIR   := KhronosGroup-SPIRV-Headers-$($(PKG)_VERSION)
$(PKG)_CHECKSUM := f88d0e61126a9b18d88ce04f2c0508e67769ddb2caa86760ec50ca42b34233e8
$(PKG)_GH_CONF  := KhronosGroup/SPIRV-Headers/branches/master
$(PKG)_TYPE     := source-only
