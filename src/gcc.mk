# This file is part of MXE.
# See index.html for further information.

PKG             := gcc
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 03b8241477a9f8a34f6efe7273d92b9b6dd9fe82
$(PKG)_SUBDIR   := gcc-$($(PKG)_VERSION)
$(PKG)_FILE     := gcc-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/gcc/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.cs.tu-berlin.de/pub/gnu/gcc/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := mingwrt w32api binutils gcc-gmp gcc-mpc gcc-mpfr

define $(PKG)_UPDATE
    wget -q -O- 'http://ftp.gnu.org/gnu/gcc/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="gcc-\([0-9][^"]*\)/".*,\1,p' | \
    grep -v '^4\.[543]\.' | \
    head -1
endef

define $(PKG)_BUILD
    # unpack support libraries
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,gcc-gmp)
    mv '$(1)/$(gcc-gmp_SUBDIR)' '$(1)/gmp'
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,gcc-mpc)
    mv '$(1)/$(gcc-mpc_SUBDIR)' '$(1)/mpc'
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,gcc-mpfr)
    mv '$(1)/$(gcc-mpfr_SUBDIR)' '$(1)/mpfr'

    # build GCC and support libraries
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
        --disable-sjlj-exceptions \
        --without-x \
        --disable-win32-registry \
        --enable-threads=win32 \
        --disable-libgomp \
        --disable-libmudflap \
        --with-mpfr-include='$(1)/mpfr/src' \
        --with-mpfr-lib='$(1).build/mpfr/src/.libs'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install

    # create pkg-config script
    (echo '#!/bin/sh'; \
     echo 'MXE_PREFIX="$$(cd $$(dirname $$0)/.. && pwd)"'; \
     echo 'PKG_CONFIG_PATH="$${PKG_CONFIG_PATH_$(subst -,_,$(TARGET))}:$${MXE_PREFIX}/$(TARGET)/share/pkgconfig" PKG_CONFIG_LIBDIR="$${MXE_PREFIX}/$(TARGET)/lib/pkgconfig" exec pkg-config --static "$$@"') \
             > '$(PREFIX)/bin/$(TARGET)-pkg-config'
    chmod 0755 '$(PREFIX)/bin/$(TARGET)-pkg-config'

    # create the CMake toolchain file
    [ -d '$(dir $(CMAKE_TOOLCHAIN_FILE))' ] || mkdir -p '$(dir $(CMAKE_TOOLCHAIN_FILE))'
    (echo 'set(BUILD_SHARED_LIBS OFF)'; \
     echo 'set(CMAKE_SYSTEM_NAME Windows)'; \
     echo 'set(MSYS 1)'; \
     echo 'get_filename_component(MXE_CMAKEDIR "$${CMAKE_CURRENT_LIST_FILE}" PATH)'; \
     echo 'get_filename_component(MXE_PREFIX "$${MXE_CMAKEDIR}/../../.." ABSOLUTE)'; \
     echo 'set(CMAKE_FIND_ROOT_PATH $${MXE_PREFIX}/$(TARGET))'; \
     echo 'set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)'; \
     echo 'set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)'; \
     echo 'set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)'; \
     echo 'set(CMAKE_C_COMPILER $${MXE_PREFIX}/bin/$(TARGET)-gcc)'; \
     echo 'set(CMAKE_CXX_COMPILER $${MXE_PREFIX}/bin/$(TARGET)-g++)'; \
     echo 'set(CMAKE_Fortran_COMPILER $${MXE_PREFIX}/bin/$(TARGET)-gfortran)'; \
     echo 'set(CMAKE_RC_COMPILER $${MXE_PREFIX}/bin/$(TARGET)-windres)'; \
     echo 'set(PKG_CONFIG_EXECUTABLE $${MXE_PREFIX}/bin/$(TARGET)-pkg-config)'; \
     echo 'set(QT_QMAKE_EXECUTABLE $${MXE_PREFIX}/bin/$(TARGET)-qmake)'; \
     echo 'set(CMAKE_INSTALL_PREFIX $${MXE_PREFIX}/$(TARGET) CACHE PATH "Installation Prefix")'; \
     echo 'set(CMAKE_BUILD_TYPE Release CACHE STRING "Debug|Release|RelWithDebInfo|MinSizeRel")') \
     > '$(CMAKE_TOOLCHAIN_FILE)'
endef
