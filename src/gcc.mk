# This file is part of MXE.
# See index.html for further information.

PKG             := gcc
$(PKG)_IGNORE   := 5%
$(PKG)_VERSION  := 4.9.3
$(PKG)_CHECKSUM := 2332b2a5a321b57508b9031354a8503af6fdfb868b8c1748d33028d100a8b67e
$(PKG)_SUBDIR   := gcc-$($(PKG)_VERSION)
$(PKG)_FILE     := gcc-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://ftp.gnu.org/pub/gnu/gcc/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(PHASE_2_TARGETS) $(MXE_TARGETS)
$(PKG)_DEPS     := binutils pkgconf

$(PKG)_FILE_$(BUILD) :=

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
        --enable-shared \
        --disable-multilib \
        --without-x \
        --disable-win32-registry \
        --enable-threads=$(MXE_GCC_THREADS) \
        $(MXE_GCC_EXCEPTION_OPTS) \
        --enable-libgomp \
        --with-gmp='$(PREFIX)/$(BUILD)' \
        --with-isl='$(PREFIX)/$(BUILD)' \
        --with-mpc='$(PREFIX)/$(BUILD)' \
        --with-mpfr='$(PREFIX)/$(BUILD)' \
        --with-cloog='$(PREFIX)/$(BUILD)' \
        --with-as='$(PREFIX)/bin/$(TARGET)-as' \
        --with-ld='$(PREFIX)/bin/$(TARGET)-ld' \
        --with-nm='$(PREFIX)/bin/$(TARGET)-nm' \
        $(shell [ `uname -s` == Darwin ] && echo "LDFLAGS='-Wl,-no_pie'") \
        $(MXE_GCC_CONFIGURE_OPTS)
endef

define $(PKG)_POST_BUILD
    # TODO: find a way to configure the installation of these correctly
    # ignore rm failure as parallel build may have cleaned up, but
    # don't wildcard all libs so future additions will be detected
    mv  -v '$(PREFIX)/lib/gcc/$(TARGET)/$($(PKG)_VERSION)/'*.dll '$(PREFIX)/$(TARGET)/bin/gcc-$($(PKG)_VERSION)/'
    -rm -v '$(PREFIX)/lib/gcc/$(TARGET)/'libgcc_s*.dll
    -rm -v '$(PREFIX)/lib/gcc/$(TARGET)/lib/'libgcc_s*.a
    -rmdir '$(PREFIX)/lib/gcc/$(TARGET)/lib/'
endef

define $(PKG)_BUILD_mingw-w64
    # install mingw-w64 headers
    $(call PREPARE_PKG_SOURCE,mingw-w64,$(1))
    mkdir '$(1).headers-build'
    cd '$(1).headers-build' && '$(1)/$(mingw-w64_SUBDIR)/mingw-w64-headers/configure' \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-sdk=all \
        --enable-idl
    $(MAKE) -C '$(1).headers-build' install

    # build standalone gcc
    $($(PKG)_CONFIGURE)
    $(MAKE) -C '$(1).build' -j '$(JOBS)' all-gcc
    $(MAKE) -C '$(1).build' -j 1 install-gcc

    # build mingw-w64-crt
    mkdir '$(1).crt-build'
    cd '$(1).crt-build' && '$(1)/$(mingw-w64_SUBDIR)/mingw-w64-crt/configure' \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        @gcc-crt-config-opts@
    $(MAKE) -C '$(1).crt-build' -j '$(JOBS)' || $(MAKE) -C '$(1).crt-build' -j '$(JOBS)'
    $(MAKE) -C '$(1).crt-build' -j 1 install

    # build posix threads
    mkdir '$(1).pthread-build'
    cd '$(1).pthread-build' && '$(1)/$(mingw-w64_SUBDIR)/mingw-w64-libraries/winpthreads/configure' \
        --host='$(TARGET)' \
        --build='$(BUILD)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-static \
        --enable-shared
    $(MAKE) -C '$(1).pthread-build' -j '$(JOBS)' || $(MAKE) -C '$(1).pthread-build' -j '$(JOBS)'
    $(MAKE) -C '$(1).pthread-build' -j 1 install

    # build rest of gcc
    cd '$(1).build'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install

    # shared libgcc isn't installed to version-specific locations
    # so install correctly to avoid clobbering with multiple versions
    $(MAKE) -C '$(1).build/$(TARGET)/libgcc' -j 1 \
        toolexecdir='$(PREFIX)/$(TARGET)/bin/gcc-$($(PKG)_VERSION)' \
        SHLIB_SLIBDIR_QUAL= \
        install-shared

    $($(PKG)_POST_BUILD)
endef

$(PKG)_BUILD_x86_64-w64-mingw32 = $(subst @gcc-crt-config-opts@,--disable-lib32,$($(PKG)_BUILD_mingw-w64))
$(PKG)_BUILD_i686-w64-mingw32   = $(subst @gcc-crt-config-opts@,--disable-lib64,$($(PKG)_BUILD_mingw-w64))

# list of programs to wrap or symlink
$(PKG)_PROGS := c++ cpp g++ gcc gcc-$($(PKG)_VERSION) gfortran
$(PKG)_LINKS := gcc-ar gcc-nm gcc-ranlib gcov

define $(PKG)_BUILD_SYMLINK_WRAP
    #create symlinks
    $(foreach PKG,$($(PKG)_LINKS),\
        ln -sf '$(PREFIX)/bin/$(1)-$(PKG)' \
               '$(PREFIX)/bin/$(TARGET)-$(PKG)';)

    # setup spec file:
    # https://gcc.gnu.org/onlinedocs/gcc/Spec-Files.html
    # can't use *link for `-L` as gcc will send that option to `ld` before
    # any `-L` specified on the command line
    (echo '*mxe_prefix:'; \
     echo '$(PREFIX)/$(TARGET)'; \
     echo ''; \
     echo '*mxe_includes:'; \
     echo '-isystem %(mxe_prefix)/include'; \
     echo ''; \
     echo '*cpp:'; \
     echo '+ %(mxe_includes)'; \
     echo ''; \
     echo '*cc1:'; \
     echo '+ %(mxe_includes)'; \
     echo ''; \
     echo '*cc1plus:'; \
     echo '+ %(mxe_includes)'; \
    ) > '$(PREFIX)/lib/gcc/$(1)/$($(PKG)_VERSION)/mxe-$(TARGET)'

    # create wrapper scripts to use spec file.
    # to review gcc invocation use the -### option e.g:
    # echo "" | i686-w64-mingw32.shared-gcc -### -xc - 2>&1 | tr ':' '\n'
    # libtool sometimes uses `-print-search-dirs` to determine paths,
    # use `-B` option to ensure this works.
    $(foreach PKG,$($(PKG)_PROGS),\
        (echo '#!/bin/sh'; \
         echo 'exec "$(PREFIX)/bin/$(1)-$(PKG)" "$$@" \
                        -specs=mxe-$(TARGET) \
                        -L"$(PREFIX)/$(TARGET)/lib" \
                        -B"$(PREFIX)/$(TARGET)/lib"' \
        ) > '$(PREFIX)/bin/$(TARGET)-$(PKG)'; \
        chmod 0755 '$(PREFIX)/bin/$(TARGET)-$(PKG)';)
endef

$(foreach TARGET,$(MXE_TARGETS), \
    $(eval $(PKG)_BUILD_$(TARGET) := $$(call $(PKG)_BUILD_SYMLINK_WRAP,$$(call GET_PHASE_2_TARGET,$(TARGET)))) \
    $(eval $(PKG)_FILE_$(TARGET)  :=))

define $(PKG)_BUILD_$(BUILD)
    for f in c++ cpp g++ gcc gcov; do \
        ln -sf "`which $$f`" '$(PREFIX)/bin/$(TARGET)'-$$f ; \
    done
endef
