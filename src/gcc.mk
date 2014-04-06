# This file is part of MXE.
# See index.html for further information.

PKG             := gcc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.8.2
$(PKG)_CHECKSUM := 810fb70bd721e1d9f446b6503afe0a9088b62986
$(PKG)_SUBDIR   := gcc-$($(PKG)_VERSION)
$(PKG)_FILE     := gcc-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/gcc/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := binutils gcc-cloog gcc-gmp gcc-isl gcc-mpc gcc-mpfr

$(PKG)_DEPS_i686-pc-mingw32    := $($(PKG)_DEPS) mingwrt w32api
$(PKG)_DEPS_i686-w64-mingw32   := $($(PKG)_DEPS) mingw-w64
$(PKG)_DEPS_x86_64-w64-mingw32 := $($(PKG)_DEPS) mingw-w64

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/gcc/?C=M;O=D' | \
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
        --enable-threads=win32 \
        --disable-libgomp \
        --disable-libmudflap \
        --with-cloog='$(PREFIX)' \
        --with-gmp='$(PREFIX)' \
        --with-isl='$(PREFIX)' \
        --with-mpc='$(PREFIX)' \
        --with-mpfr='$(PREFIX)' \
        --with-as='$(PREFIX)/bin/$(TARGET)-as' \
        --with-ld='$(PREFIX)/bin/$(TARGET)-ld' \
        --with-nm='$(PREFIX)/bin/$(TARGET)-nm' \
        $(shell [ `uname -s` == Darwin ] && echo "LDFLAGS='-Wl,-no_pie'")
endef

define $(PKG)_POST_BUILD
    # TODO: find a way to configure the installation of these correctly
    rm -f $(addprefix $(PREFIX)/$(TARGET)/bin/, c++ g++ gcc gfortran)
    -mv '$(PREFIX)/lib/gcc/$(TARGET)/lib/'* '$(PREFIX)/lib/gcc/$(TARGET)/$($(PKG)_VERSION)/'
    -cp '$(PREFIX)/lib/gcc/$(TARGET)/'*.dll '$(PREFIX)/$(TARGET)/bin/'
    -mv '$(PREFIX)/lib/gcc/$(TARGET)/'*.dll '$(PREFIX)/lib/gcc/$(TARGET)/$($(PKG)_VERSION)/'
endef

define $(PKG)_BUILD_i686-pc-mingw32
    # build full cross gcc
    $($(PKG)_CONFIGURE) \
        --disable-sjlj-exceptions
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install

    $($(PKG)_POST_BUILD)
endef

define $(PKG)_BUILD_mingw-w64
    # build standalone gcc
    $($(PKG)_CONFIGURE)
    $(MAKE) -C '$(1).build' -j '$(JOBS)' all-gcc
    $(MAKE) -C '$(1).build' -j 1 install-gcc

    # build mingw-w64-crt
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,mingw-w64)
    mkdir '$(1).crt-build'
    cd '$(1).crt-build' && '$(1)/$(mingw-w64_SUBDIR)/mingw-w64-crt/configure' \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        @gcc-crt-config-opts@
    $(MAKE) -C '$(1).crt-build' -j '$(JOBS)' || $(MAKE) -C '$(1).crt-build' -j '$(JOBS)'
    $(MAKE) -C '$(1).crt-build' -j 1 install

    # build rest of gcc
    cd '$(1).build'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install

    $($(PKG)_POST_BUILD)
endef

$(PKG)_BUILD_x86_64-w64-mingw32 = $(subst @gcc-crt-config-opts@,--disable-lib32,$($(PKG)_BUILD_mingw-w64))
$(PKG)_BUILD_i686-w64-mingw32   = $(subst @gcc-crt-config-opts@,--disable-lib64,$($(PKG)_BUILD_mingw-w64))

define $(PKG)_BUILD_$(BUILD)
    for f in c++ cpp g++ gcc gcov; do \
        ln -sf "`which $$f`" '$(PREFIX)/bin/$(TARGET)'-$$f ; \
    done
endef
