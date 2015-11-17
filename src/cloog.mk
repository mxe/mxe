# This file is part of MXE.
# See index.html for further information.

PKG             := cloog
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.18.1
$(PKG)_CHECKSUM := 02500a4edd14875f94fe84cbeda4290425cb0c1c2474c6f75d75a303d64b4196
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.bastoul.net/cloog/pages/download/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://gcc.gnu.org/pub/gcc/infrastructure/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := gcc gmp isl

$(PKG)_DEPS_$(BUILD) := gmp isl

# stick to tested versions from gcc
define $(PKG)_UPDATE
    $(WGET) -q -O- 'ftp://gcc.gnu.org/pub/gcc/infrastructure/' | \
    $(SED) -n 's,.*cloog-\([0-9][^>]*\)\.tar.*,\1,p' | \
    $(SORT) -V |
    tail -1
endef

define $(PKG)_BUILD_$(BUILD)
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-gmp-prefix='$(PREFIX)/$(TARGET)' \
        --with-isl-prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef

$(PKG)_BUILD_SHARED =
