# This file is part of MXE.
# See index.html for further information.

PKG             := gcc
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := b4ee6e9bdebc65223f95067d0cc1a634b59dad72
$(PKG)_SUBDIR   := gcc-$($(PKG)_VERSION)
$(PKG)_FILE     := gcc-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/gcc/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := mingwrt w32api mingw-w64 binutils gcc-gmp gcc-mpc gcc-mpfr

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/gcc/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="gcc-\([0-9][^"]*\)/".*,\1,p' | \
    grep -v '^4\.[543]\.' | \
    head -1
endef

define $(PKG)_PRE_CONFIGURE
    # unpack support libraries
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,gcc-gmp)
    mv '$(1)/$(gcc-gmp_SUBDIR)' '$(1)/gmp'
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,gcc-mpc)
    mv '$(1)/$(gcc-mpc_SUBDIR)' '$(1)/mpc'
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,gcc-mpfr)
    mv '$(1)/$(gcc-mpfr_SUBDIR)' '$(1)/mpfr'
endef

define $(PKG)_CONFIGURE
    # configure gcc and support libraries
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --target='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)' \
        --libdir='$(PREFIX)/lib' \
        --enable-languages='c,c++,objc,fortran' \
        --enable-version-specific-runtime-libs \
        --with-gcc \
        --with-gnu-ld \
        --with-gnu-as \
        --disable-nls \
        --disable-shared \
        --disable-multilib \
        --without-x \
        --disable-win32-registry \
        --enable-threads=win32 \
        --disable-libgomp \
        --disable-libmudflap \
        --with-mpfr-include='$(1)/mpfr/src' \
        --with-mpfr-lib='$(1).build/mpfr/src/.libs' \
        $(shell [ `uname -s` == Darwin ] && echo "LDFLAGS='-Wl,-no_pie'")
endef

define $(PKG)_POST_BUILD
    # create pkg-config script
    (echo '#!/bin/sh'; \
     echo 'PKG_CONFIG_PATH="$$PKG_CONFIG_PATH_$(subst -,_,$(TARGET))" PKG_CONFIG_LIBDIR='\''$(PREFIX)/$(TARGET)/lib/pkgconfig'\'' exec pkg-config --static "$$@"') \
             > '$(PREFIX)/bin/$(TARGET)-pkg-config'
    chmod 0755 '$(PREFIX)/bin/$(TARGET)-pkg-config'

    # create the CMake toolchain file
    [ -d '$(dir $(CMAKE_TOOLCHAIN_FILE))' ] || mkdir -p '$(dir $(CMAKE_TOOLCHAIN_FILE))'
    (echo 'set(CMAKE_SYSTEM_NAME Windows)'; \
     echo 'set(MSYS 1)'; \
     echo 'set(BUILD_SHARED_LIBS OFF)'; \
     echo 'set(CMAKE_BUILD_TYPE Release)'; \
     echo 'set(CMAKE_FIND_ROOT_PATH $(PREFIX)/$(TARGET))'; \
     echo 'set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)'; \
     echo 'set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)'; \
     echo 'set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)'; \
     echo 'set(CMAKE_C_COMPILER $(PREFIX)/bin/$(TARGET)-gcc)'; \
     echo 'set(CMAKE_CXX_COMPILER $(PREFIX)/bin/$(TARGET)-g++)'; \
     echo 'set(CMAKE_Fortran_COMPILER $(PREFIX)/bin/$(TARGET)-gfortran)'; \
     echo 'set(CMAKE_RC_COMPILER $(PREFIX)/bin/$(TARGET)-windres)'; \
     echo 'set(PKG_CONFIG_EXECUTABLE $(PREFIX)/bin/$(TARGET)-pkg-config)'; \
     echo 'set(QT_QMAKE_EXECUTABLE $(PREFIX)/bin/$(TARGET)-qmake)'; \
     echo 'set(CMAKE_INSTALL_PREFIX $(PREFIX)/$(TARGET) CACHE PATH "Installation Prefix")'; \
     echo 'set(CMAKE_BUILD_TYPE Release CACHE STRING "Debug|Release|RelWithDebInfo|MinSizeRel")') \
     > '$(CMAKE_TOOLCHAIN_FILE)'
endef

define $(PKG)_POST_BUILD_mingw32
    # create pkg-config files
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: gl'; \
     echo 'Version: 0'; \
     echo 'Description: OpenGL'; \
     echo 'Libs: -lopengl32';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/gl.pc'

    (echo 'Name: glu'; \
     echo 'Version: 0'; \
     echo 'Description: OpenGL'; \
     echo 'Libs: -lglu32';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/glu.pc'
endef

define $(PKG)_BUILD_i686-pc-mingw32
    # build full cross gcc
    $($(PKG)_PRE_CONFIGURE) \
    $($(PKG)_CONFIGURE) \
        --disable-sjlj-exceptions
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
    $($(PKG)_POST_BUILD)
    $($(PKG)_POST_BUILD_mingw32)
endef

define $(PKG)_BUILD_mingw-w64
    # build standalone gcc
    $($(PKG)_PRE_CONFIGURE) \
    $($(PKG)_CONFIGURE) \
        --enable-sjlj-exceptions
    $(MAKE) -C '$(1).build' -j '$(JOBS)' all-gcc
    $(MAKE) -C '$(1).build' -j 1 install-gcc

    # build mingw-w64-crt
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,mingw-w64)
    mkdir '$(1).crt-build'
    cd '$(1).crt-build' && '$(1)/$(mingw-w64_SUBDIR)/mingw-w64-crt/configure' \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)' \
        mxe-config-opts
    $(MAKE) -C '$(1).crt-build' -j '$(JOBS)'
    $(MAKE) -C '$(1).crt-build' -j 1 install

    # build rest of gcc
    cd '$(1).build'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install

    $($(PKG)_POST_BUILD)
    $($(PKG)_POST_BUILD_mingw32)
endef

$(PKG)_BUILD_x86_64-w64-mingw32 = $(subst mxe-config-opts,--disable-lib32,$($(PKG)_BUILD_mingw-w64))
$(PKG)_BUILD_i686-w64-mingw32   = $(subst mxe-config-opts,--disable-lib64,$($(PKG)_BUILD_mingw-w64))
