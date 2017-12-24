# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cc
$(PKG)_WEBSITE  := https://mxe.cc
$(PKG)_DESCR    := Dependency package for cross libraries
$(PKG)_VERSION  := 1
$(PKG)_DEPS     := gcc
$(PKG)_OO_DEPS   = pkgconf $(MXE_REQS_PKGS)
$(PKG)_TYPE     := meta
