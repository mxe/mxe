# This file is part of MXE. See LICENSE.md for licensing information.

PKG_BASENAME    := glslang
PKG             := $(PKG_BASENAME)-src
$(PKG)_WEBSITE  := https://github.com/KhronosGroup/glslang
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.9.2888
$(PKG)_SUBDIR   := $(PKG_BASENAME)-$($(PKG)_VERSION)
$(PKG)_CHECKSUM := cb66779d0e6b5f07f0445bd58289a24e56e12693e71d75c8fae3db31ffacaf8c
# Not sure how to set this up properly
$(PKG)_GH_CONF  := KhronosGroup/glslang/tags/7.9.2888
$(PKG)_TYPE     := source-only
