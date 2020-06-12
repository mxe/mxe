# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gcc
$(PKG)_WEBSITE  := https://gcc.gnu.org/
$(PKG)_DESCR    := GCC
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.5.0
$(PKG)_CHECKSUM := 530cea139d82fe542b358961130c69cfde8b3d14556370b65823d2f91f0ced87
$(PKG)_SUBDIR   := gcc-$($(PKG)_VERSION)
$(PKG)_FILE     := gcc-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://ftp.gnu.org/gnu/gcc/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := https://www.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := binutils mingw-w64 $(addprefix $(BUILD)~,gmp isl mpc mpfr)

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/gcc/?C=M;O=D' | \
    grep -v 'gcc-6\|gcc-7' | \
    $(SED) -n 's,.*<a href="gcc-\([0-9][^"]*\)/".*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_CONFIGURE
    # configure gcc
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_DISABLE_DOC_OPTS) \
        --target='$(TARGET)' \
        --build='$(BUILD)' \
        --prefix='$(PREFIX)' \
        --libdir='$(PREFIX)/lib' \
        --with-sysroot='$(PREFIX)/$(TARGET)' \
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
        $(MXE_GCC_EXCEPTION_OPTS) \
        --enable-default-ssp \
        --enable-libgomp \
        --with-gmp='$(PREFIX)/$(BUILD)' \
        --with-isl='$(PREFIX)/$(BUILD)' \
        --with-mpc='$(PREFIX)/$(BUILD)' \
        --with-mpfr='$(PREFIX)/$(BUILD)' \
        --with-as='$(PREFIX)/bin/$(TARGET)-as' \
        --with-ld='$(PREFIX)/bin/$(TARGET)-ld' \
        --with-nm='$(PREFIX)/bin/$(TARGET)-nm' \
        $(shell [ `uname -s` == Darwin ] && echo "LDFLAGS='-Wl,-no_pie'") \
        $(PKG_CONFIGURE_OPTS)
endef

define $(PKG)_BUILD_mingw-w64
    # install mingw-w64 headers
    $(call PREPARE_PKG_SOURCE,mingw-w64,$(BUILD_DIR))
    mkdir '$(BUILD_DIR).headers'
    cd '$(BUILD_DIR).headers' && '$(BUILD_DIR)/$(mingw-w64_SUBDIR)/mingw-w64-headers/configure' \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-default-msvcrt=msvcrt \
        --enable-sdk=all \
        --enable-idl \
        --enable-secure-api \
        --with-default-msvcrt=msvcrt \
        $(mingw-w64-headers_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR).headers' install

    # build standalone gcc
    $($(PKG)_CONFIGURE)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' all-gcc
    $(MAKE) -C '$(BUILD_DIR)' -j 1 $(INSTALL_STRIP_TOOLCHAIN)-gcc

    # build mingw-w64-crt
    mkdir '$(BUILD_DIR).crt'
    cd '$(BUILD_DIR).crt' && '$(BUILD_DIR)/$(mingw-w64_SUBDIR)/mingw-w64-crt/configure' \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-default-msvcrt=msvcrt \
        @gcc-crt-config-opts@ \
        $(mingw-w64-crt_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR).crt' -j '$(JOBS)' || $(MAKE) -C '$(BUILD_DIR).crt' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR).crt' -j 1 $(INSTALL_STRIP_TOOLCHAIN)

    # build posix threads
    mkdir '$(BUILD_DIR).pthreads'
    cd '$(BUILD_DIR).pthreads' && '$(BUILD_DIR)/$(mingw-w64_SUBDIR)/mingw-w64-libraries/winpthreads/configure' \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR).pthreads' -j '$(JOBS)' || $(MAKE) -C '$(BUILD_DIR).pthreads' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR).pthreads' -j 1 $(INSTALL_STRIP_TOOLCHAIN)

    # build rest of gcc
    # `all-target-libstdc++-v3` sometimes has parallel failure
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' all-target-libstdc++-v3 || $(MAKE) -C '$(BUILD_DIR)' -j 1 all-target-libstdc++-v3
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 $(INSTALL_STRIP_TOOLCHAIN)

    $($(PKG)_POST_BUILD)
endef

define $(PKG)_POST_BUILD
    # - no non-trivial way to configure installation of *.dlls
    #   each sudbir has it's own variations of variables like:
    #       `toolexeclibdir` `install-toolexeclibLTLIBRARIES` etc.
    #   and maintaining those would be cumbersome
    # - shared libgcc isn't installed to version-specific locations
    # - need to keep `--enable-version-specific-runtime-libs` otherwise
    #   libraries go directly into $(PREFIX)/$(TARGET)/lib and are
    #   harder to cleanup
    # - ignore rm failure as parallel build may have cleaned up, but
    #   don't wildcard all libs so future additions will be detected
    $(and $(BUILD_SHARED),
    $(MAKE) -C '$(BUILD_DIR)/$(TARGET)/libgcc' -j 1 \
        toolexecdir='$(PREFIX)/$(TARGET)/bin' \
        SHLIB_SLIBDIR_QUAL= \
        install-shared
    mv  -v '$(PREFIX)/lib/gcc/$(TARGET)/$($(PKG)_VERSION)/'*.dll '$(PREFIX)/$(TARGET)/bin/'
    -rm -v '$(PREFIX)/lib/gcc/$(TARGET)/'libgcc_s*.dll
    -rm -v '$(PREFIX)/lib/gcc/$(TARGET)/lib/'libgcc_s*.a
    -rmdir '$(PREFIX)/lib/gcc/$(TARGET)/lib/')

    # cc1libdir isn't passed to subdirs so install correctly and rm
    $(MAKE) -C '$(BUILD_DIR)/libcc1' -j 1 install cc1libdir='$(PREFIX)/lib/gcc/$(TARGET)/$($(PKG)_VERSION)'
    -rm -f '$(PREFIX)/lib/'libcc1*

    # overwrite default specs to mimic stack protector handling of glibc
    # ./configure above doesn't do this
    '$(TARGET)-gcc' -dumpspecs > '$(PREFIX)/lib/gcc/$(TARGET)/$($(PKG)_VERSION)/specs'
    $(SED) -i 's,-lmingwex,-lmingwex -lssp_nonshared -lssp,' '$(PREFIX)/lib/gcc/$(TARGET)/$($(PKG)_VERSION)/specs'

    # compile test
    cd '$(PREFIX)/$(TARGET)/bin' && '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        -D_FORTIFY_SOURCE=2 \
        --coverage -fprofile-dir=. -v \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe'
endef

$(PKG)_BUILD_x86_64-w64-mingw32 = $(subst @gcc-crt-config-opts@,--disable-lib32,$($(PKG)_BUILD_mingw-w64))
$(PKG)_BUILD_i686-w64-mingw32   = $(subst @gcc-crt-config-opts@,--disable-lib64,$($(PKG)_BUILD_mingw-w64))
