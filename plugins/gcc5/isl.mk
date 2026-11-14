# This file is part of MXE. See LICENSE.md for licensing information.

# GCC 5.5.0 requires ISL 0.15 for Graphite loop optimizations.
# GCC 5 configure specifically tests for isl_options_set_schedule_serialize_sccs
# (introduced in ISL 0.15) to enable modern loop scheduling.
# Newer ISL releases (>= 0.16 and modern 0.24) break the C API expected by
# gcc/graphite-*.c, causing fatal compiler build errors.
# This package definition is fully self-contained to avoid inheriting from src/isl.mk.

PKG             := isl
$(PKG)_WEBSITE  := https://libisl.sourceforge.io/
$(PKG)_DESCR    := Integer Set Library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.15
$(PKG)_CHECKSUM := 8ceebbf4d9a81afa2b4449113cee4b7cb14a687d7a549a963deb5e2a41458b6b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://libisl.sourceforge.io/$($(PKG)_FILE)
$(PKG)_URL_2    := https://gcc.gnu.org/pub/gcc/infrastructure/$($(PKG)_FILE)
$(PKG)_PATCHES  :=
$(PKG)_DEPS     := cc gmp

$(PKG)_TARGETS       := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS_$(BUILD) := gmp

$(PKG)_UPDATE   :=

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-gmp-prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' $(if $(BUILD_SHARED),LDFLAGS=-no-undefined)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
