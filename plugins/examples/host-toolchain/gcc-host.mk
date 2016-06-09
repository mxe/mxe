# This file is part of MXE.
# See index.html for further information.

PKG             := gcc-host
$(PKG)_IGNORE    = $(gcc_IGNORE)
$(PKG)_VERSION   = $(gcc_VERSION)
$(PKG)_CHECKSUM  = $(gcc_CHECKSUM)
$(PKG)_SUBDIR    = $(gcc_SUBDIR)
$(PKG)_FILE      = $(gcc_FILE)
$(PKG)_URL       = $(gcc_URL)
$(PKG)_URL_2     = $(gcc_URL_2)
$(PKG)_DEPS     := gcc binutils-host cloog gmp isl mpfr mpc

define $(PKG)_UPDATE
    echo $(gcc_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --host='$(TARGET)' \
        --target='$(TARGET)' \
        --build='$(BUILD)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-native-system-header-dir='$(PREFIX)/$(TARGET)/include' \
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
        --with-{cloog,gmp,isl,mpc,mpfr}='$(PREFIX)/$(TARGET)'

    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install

    # test compilation on host
    cp '$(TOP_DIR)/src/pthreads-libgomp-test.c' '$(PREFIX)/$(TARGET)/bin/test-$(PKG).c'
    (printf 'set PATH=..\\bin;%%PATH%%\r\n'; \
     printf 'gcc test-$(PKG).c -o test-$(PKG).exe -fopenmp -v\r\n'; \
     printf 'test-$(PKG).exe\r\n'; \
     printf 'pause\r\n';) \
     > '$(PREFIX)/$(TARGET)/bin/test-$(PKG).bat'
endef
