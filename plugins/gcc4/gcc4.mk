# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gcc
$(PKG)_WEBSITE  := https://gcc.gnu.org/
$(PKG)_DESCR    := GCC
$(PKG)_IGNORE   := 5%
$(PKG)_VERSION  := 4.9.4
$(PKG)_CHECKSUM := 6c11d292cd01b294f9f84c9a59c230d80e9e4a47e5c6355f046bb36d4f358092
$(PKG)_SUBDIR   := gcc-$($(PKG)_VERSION)
$(PKG)_FILE     := gcc-$($(PKG)_VERSION).tar.bz2
$(PKG)_PATCHES  := $(basename $(lastword $(MAKEFILE_LIST))).patch
$(PKG)_URL      := https://ftp.gnu.org/gnu/gcc/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := https://www.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := binutils mingw-w64 $(addprefix $(BUILD)~,cloog gmp isl mpc mpfr)

$(PKG)_FILE_$(BUILD) :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/gcc/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="gcc-\([0-9][^"]*\)/".*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_CONFIGURE
    # configure gcc
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --target='$(TARGET)' \
        --build='$(BUILD)' \
        --prefix='$(PREFIX)' \
        --libdir='$(PREFIX)/lib' \
        --enable-languages='c,c++,objc,fortran' \
        --enable-version-specific-runtime-libs \
        --with-gcc \
        --with-gnu-ld \
        --with-gnu-as \
        --disable-nls \
        $(if $(BUILD_STATIC),--disable-shared) \
        --disable-multilib \
        --without-x \
        --disable-win32-registry \
        --enable-threads=$(MXE_GCC_THREADS) \
        --enable-libgomp \
        --with-gmp='$(PREFIX)/$(BUILD)' \
        --with-isl='$(PREFIX)/$(BUILD)' \
        --with-mpc='$(PREFIX)/$(BUILD)' \
        --with-mpfr='$(PREFIX)/$(BUILD)' \
        --with-cloog='$(PREFIX)/$(BUILD)' \
        --with-as='$(PREFIX)/bin/$(TARGET)-as' \
        --with-ld='$(PREFIX)/bin/$(TARGET)-ld' \
        --with-nm='$(PREFIX)/bin/$(TARGET)-nm' \
        $(shell [ `uname -s` == Darwin ] && echo "LDFLAGS='-Wl,-no_pie'")
endef

define $(PKG)_POST_BUILD
    # - no non-trivial way to configure installation of *.dlls
    #   each sudbir has it's own variations of variables like:
    #       `toolexeclibdir` `install-toolexeclibLTLIBRARIES` etc.
    #   and maintaining those would be cumbersome
    # - need to keep `--enable-version-specific-runtime-libs` otherwise
    #   libraries go directly into $(PREFIX)/$(TARGET)/lib and are
    #   harder to cleanup
    # - ignore rm failure as parallel build may have cleaned up, but
    #   don't wildcard all libs so future additions will be detected
    $(and $(BUILD_SHARED),
    mv  -v '$(PREFIX)/lib/gcc/$(TARGET)/$($(PKG)_VERSION)/'*.dll '$(PREFIX)/$(TARGET)/bin/'
    -rm -v '$(PREFIX)/lib/gcc/$(TARGET)/'libgcc_s*.dll
    -rm -v '$(PREFIX)/lib/gcc/$(TARGET)/lib/'libgcc_s*.a
    -rmdir '$(PREFIX)/lib/gcc/$(TARGET)/lib/')
endef

define $(PKG)_BUILD_mingw-w64
    # install mingw-w64 headers
    $(call PREPARE_PKG_SOURCE,mingw-w64,$(1))
    mkdir '$(1).headers-build'
    cd '$(1).headers-build' && '$(1)/$(mingw-w64_SUBDIR)/mingw-w64-headers/configure' \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-sdk=all \
        --enable-idl \
        --enable-secure-api \
        $(mingw-w64-headers_CONFIGURE_OPTS)
    $(MAKE) -C '$(1).headers-build' install

    # build standalone gcc
    $($(PKG)_CONFIGURE)
    $(MAKE) -C '$(1).build' -j '$(JOBS)' all-gcc
    $(MAKE) -C '$(1).build' -j 1 $(INSTALL_STRIP_TOOLCHAIN)-gcc

    # build mingw-w64-crt
    mkdir '$(1).crt-build'
    cd '$(1).crt-build' && '$(1)/$(mingw-w64_SUBDIR)/mingw-w64-crt/configure' \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        @gcc-crt-config-opts@
    $(MAKE) -C '$(1).crt-build' -j '$(JOBS)' || $(MAKE) -C '$(1).crt-build' -j '$(JOBS)'
    $(MAKE) -C '$(1).crt-build' -j 1 $(INSTALL_STRIP_TOOLCHAIN)

    # build posix threads
    mkdir '$(1).pthread-build'
    cd '$(1).pthread-build' && '$(1)/$(mingw-w64_SUBDIR)/mingw-w64-libraries/winpthreads/configure' \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1).pthread-build' -j '$(JOBS)' || $(MAKE) -C '$(1).pthread-build' -j '$(JOBS)'
    $(MAKE) -C '$(1).pthread-build' -j 1 $(INSTALL_STRIP_TOOLCHAIN)

    # build rest of gcc
    cd '$(1).build'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 $(INSTALL_STRIP_TOOLCHAIN)

    # shared libgcc isn't installed to version-specific locations
    # so install correctly to simplify cleanup
    $(and $(BUILD_SHARED),
    $(MAKE) -C '$(1).build/$(TARGET)/libgcc' -j 1 \
        toolexecdir='$(PREFIX)/$(TARGET)/bin' \
        SHLIB_SLIBDIR_QUAL= \
        install-shared)

    $($(PKG)_POST_BUILD)
endef

$(PKG)_BUILD_x86_64-w64-mingw32 = $(subst @gcc-crt-config-opts@,--disable-lib32,$($(PKG)_BUILD_mingw-w64))
$(PKG)_BUILD_i686-w64-mingw32   = $(subst @gcc-crt-config-opts@,--disable-lib64,$($(PKG)_BUILD_mingw-w64))

define $(PKG)_BUILD_$(BUILD)
    for f in c++ cpp g++ gcc gcov; do \
        ln -sf "`which $$f`" '$(PREFIX)/bin/$(TARGET)'-$$f ; \
    done
endef
