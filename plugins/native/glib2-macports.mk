# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := glib2-macports
$(PKG)_WEBSITE  := packages.macports.org
$(PKG)_DESCR    := glib2 pre-built macports package
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.50.3
$(PKG)_CHECKSUM := b7327d69c8a32d2f4ec4e885c0de189618ca6cd54999c62d1de5d37d78c515cd
$(PKG)_SUBDIR   := .
$(PKG)_FILE     := glib2-$($(PKG)_VERSION)_0.darwin_16.x86_64.tbz2
$(PKG)_URL      := https://packages.macports.org/glib2/glib2-$($(PKG)_VERSION)_0.darwin_16.x86_64.tbz2
$(PKG)_DEPS     :=
$(PKG)_TARGETS  := $(BUILD)
$(PKG)_TYPE     := source-only

MXE_REQS_PKGS   += $(BUILD)~glib2-macports

define $(PKG)_UPDATE
    echo 'manually update glib2-macports as necessary' >&2;
    echo $(glib2-macports_VERSION)
endef
