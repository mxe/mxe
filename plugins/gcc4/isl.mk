# This file is part of MXE. See LICENSE.md for licensing information.

# GCC 4.9.4 and CLooG 0.18.1 strictly require ISL 0.12.2 for Graphite loop
# optimizations. GCC 4.9 configure enforces this via:
#   strncmp (isl_version (), "isl-0.12", 8)
# Newer ISL releases (>= 0.14) remove required C APIs and are rejected by
# GCC 4.9 configure.
# This package definition is fully self-contained to avoid inheriting from src/isl.mk.

PKG             := isl
$(PKG)_WEBSITE  := https://libisl.sourceforge.io/
$(PKG)_DESCR    := Integer Set Library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.12.2
$(PKG)_CHECKSUM := f4b3dbee9712850006e44f0db2103441ab3d13b406f77996d1df19ee89d11fb4
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
