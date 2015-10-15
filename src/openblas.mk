# This file is part of MXE.
# See index.html for further information.

PKG             := openblas
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.2.12
$(PKG)_CHECKSUM := b41f71f46faab1215f6f6d17541113dc01fd4d8fee0694f3f459bc2e3c2aaaaf
$(PKG)_SUBDIR   := OpenBLAS-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := http://github.com/xianyi/OpenBLAS/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc libgomp

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
