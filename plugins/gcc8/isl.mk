# This file is part of MXE. See LICENSE.md for licensing information.

# GCC 8.5.0 officially recommends ISL 0.18 for Graphite loop optimizations
# (see gcc-8.5.0/contrib/download_prerequisites).
# Newer ISL versions (>= 0.20 and modern 0.24 in src/isl.mk) remove required
# configure options and break C API compatibility.
# This package definition is fully self-contained to avoid inheriting from src/isl.mk.

PKG             := isl
$(PKG)_WEBSITE  := https://libisl.sourceforge.io/
$(PKG)_DESCR    := Integer Set Library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.18
$(PKG)_CHECKSUM := 6b8b0fd7f81d0a957beb3679c81bbb34ccc7568d5682844d8924424a0dadcb1b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://libisl.sourceforge.io/$($(PKG)_FILE)
$(PKG)_URL_2    := https://gcc.gnu.org/pub/gcc/infrastructure/$($(PKG)_FILE)
$(PKG)_PATCHES  :=
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := cc gmp
$(PKG)_DEPS_$(BUILD) := gmp

$(PKG)_UPDATE   :=

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-gmp-prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' $(if $(BUILD_SHARED),LDFLAGS=-no-undefined)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
