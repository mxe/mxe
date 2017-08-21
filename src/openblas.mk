# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := openblas
$(PKG)_WEBSITE  := http://www.openblas.net/
$(PKG)_DESCR    := OpenBLAS
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.2.15
$(PKG)_CHECKSUM := 73c40ace5978282224e5e122a41c8388c5a19e65a6f2329c2b7c0b61bacc9044
$(PKG)_SUBDIR   := OpenBLAS-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://github.com/xianyi/OpenBLAS/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc pthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/xianyi/OpenBLAS/releases' | \
    $(SED) -n 's,.*OpenBLAS/archive/v\([0-9][^"]*\)\.tar\.gz.*,\1,p' | \
    grep -v 'rc' | \
    $(SORT) -V | \
    tail -1
endef

$(PKG)_MAKE_OPTS = \
        PREFIX='$(PREFIX)/$(TARGET)' \
        CROSS_SUFFIX='$(TARGET)-' \
        FC='$(TARGET)-gfortran' \
        CC='$(TARGET)-gcc' \
        HOSTCC='$(BUILD_CC)' \
        CROSS=1 \
        NO_CBLAS=1 \
        NO_LAPACK=1 \
        USE_THREAD=1 \
        USE_OPENMP=1 \
        TARGET=CORE2 \
        DYNAMIC_ARCH=1 \
        ARCH=$(strip \
             $(if $(findstring x86_64,$(TARGET)),x86_64,\
             $(if $(findstring i686,$(TARGET)),x86))) \
        BINARY=$(BITS) \
        $(if $(BUILD_STATIC),NO_SHARED=1) \
        $(if $(BUILD_SHARED),NO_STATIC=1) \
        EXTRALIB="`'$(TARGET)-pkg-config' --libs pthreads` -fopenmp"

define $(PKG)_BUILD
    $(MAKE) -C '$(1)' -j '$(JOBS)' $($(PKG)_MAKE_OPTS)
    $(MAKE) -C '$(1)' -j 1 install $($(PKG)_MAKE_OPTS)
endef
