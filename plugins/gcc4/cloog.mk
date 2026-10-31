# This file is part of MXE. See LICENSE.md for licensing information.

# GCC 4.9.4 requires CLooG 0.18.1 for Graphite polyhedral loop generation.
# CLooG 0.18.1 is built for $(BUILD) (host toolchain dependency for GCC 4)
# and $(MXE_TARGETS). It is tightly coupled to ISL 0.12.2.
# Modern CLooG (>= 0.20) in src/cloog.mk is incompatible with ISL 0.12.2.
# This package definition is fully self-contained to avoid inheriting from src/cloog.mk.

PKG             := cloog
$(PKG)_WEBSITE  := https://github.com/periscop/cloog
$(PKG)_DESCR    := CLooG Code Generator
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.18.1
$(PKG)_CHECKSUM := 02500a4edd14875f94fe84cbeda4290425cb0c1c2474c6f75d75a303d64b4196
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.bastoul.net/cloog/pages/download/$($(PKG)_FILE)
$(PKG)_URL_2    := https://gcc.gnu.org/pub/gcc/infrastructure/$($(PKG)_FILE)
$(PKG)_PATCHES  :=
$(PKG)_DEPS     := cc gmp isl

$(PKG)_TARGETS       := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS_$(BUILD) := gmp isl

$(PKG)_UPDATE   :=

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-gmp-prefix='$(PREFIX)/$(TARGET)' \
        --with-isl-prefix='$(PREFIX)/$(TARGET)' \
        ac_cv_prog_TEXI2DVI=
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(if $(BUILD_SHARED),LDFLAGS=-no-undefined)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
