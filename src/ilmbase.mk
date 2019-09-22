# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ilmbase
$(PKG)_WEBSITE  := https://www.openexr.com/
$(PKG)_DESCR    := IlmBase
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3.0
$(PKG)_CHECKSUM := 456978d1a978a5f823c7c675f3f36b0ae14dba36638aeaa3c4b0e784f12a3862
$(PKG)_SUBDIR   := ilmbase-$($(PKG)_VERSION)
$(PKG)_FILE     := ilmbase-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://download.savannah.nongnu.org/releases/openexr/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.openexr.com/downloads.html' | \
    grep 'ilmbase-' | \
    $(SED) -n 's,.*/ilmbase-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

GCC_VERSION_MAJOR := $(shell echo $(gcc_VERSION) | cut -f1 -d.)
GCC_VERSION_MINOR := $(shell echo $(gcc_VERSION) | cut -f2 -d.)

$(PKG)_CXXSTD_14 := $(shell [ $(GCC_VERSION_MAJOR) -gt 6 -o \( $(GCC_VERSION_MAJOR) -eq 6 -a $(GCC_VERSION_MINOR) -ge 1 \) ] && echo true)

define $(PKG)_BUILD
    cd '$(1)' && $(SHELL) ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-threading \
        --disable-posix-sem \
        --enable-cxxstd=$(if $($(PKG)_CXXSTD_14),14,11) \
        CONFIG_SHELL=$(SHELL) \
        SHELL=$(SHELL)
    # do the first build step by hand, because programs are built that
    # generate source files
    cd '$(1)/Half' && $(BUILD_CXX) eLut.cpp -o eLut
    '$(1)/Half/eLut' > '$(1)/eLut.h'
    cd '$(1)/Half' && $(BUILD_CXX) toFloat.cpp -o toFloat
    '$(1)/Half/toFloat' > '$(1)/toFloat.h'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
