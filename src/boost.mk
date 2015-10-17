# This file is part of MXE.
# See index.html for further information.

PKG             := boost
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.57.0
$(PKG)_CHECKSUM := 910c8c022a33ccec7f088bd65d4f14b466588dda94ba2124e78b8c57db264967
$(PKG)_SUBDIR   := boost_$(subst .,_,$($(PKG)_VERSION))
$(PKG)_FILE     := boost_$(subst .,_,$($(PKG)_VERSION)).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/boost/boost/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc bzip2 expat zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.boost.org/users/download/' | \
    $(SED) -n 's,.*/boost/\([0-9][^"/]*\)/".*,\1,p' | \
    grep -v beta | \
    head -1
endef

define $(PKG)_BUILD
    # old version appears to interfere
    rm -rf '$(PREFIX)/$(TARGET)/include/boost/'
    rm -f "$(PREFIX)/$(TARGET)/lib/libboost"*

    # create user-config
    echo 'using gcc : mxe : $(TARGET)-g++ : <rc>$(TARGET)-windres <archiver>$(TARGET)-ar <ranlib>$(TARGET)-ranlib ;' > '$(1)/user-config.jam'

    # compile boost build (b2)
    cd '$(1)/tools/build/' && ./bootstrap.sh

    # cross-build, see b2 options at:
    # http://www.boost.org/build/doc/html/bbv2/overview/invocation.html
    cd '$(1)' && ./tools/build/b2 \
        -a \
        -q \
        -j '$(JOBS)' \
        --ignore-site-config \
        --user-config=user-config.jam \
        address-model=$(BITS) \
        architecture=x86 \
        binary-format=pe \
        link=$(if $(BUILD_STATIC),static,shared) \
        target-os=windows \
        threadapi=win32 \
        threading=multi \
        variant=release \
        toolset=gcc-mxe \
        --layout=tagged \
        --disable-icu \
        --without-mpi \
        --without-python \
        --prefix='$(PREFIX)/$(TARGET)' \
        --exec-prefix='$(PREFIX)/$(TARGET)/bin' \
        --libdir='$(PREFIX)/$(TARGET)/lib' \
        --includedir='$(PREFIX)/$(TARGET)/include' \
        -sEXPAT_INCLUDE='$(PREFIX)/$(TARGET)/include' \
        -sEXPAT_LIBPATH='$(PREFIX)/$(TARGET)/lib' \
        install

    $(if $(BUILD_SHARED), \
        mv -fv '$(PREFIX)/$(TARGET)/lib/'libboost_*.dll '$(PREFIX)/$(TARGET)/bin/')

    # setup cmake toolchain
    echo 'set(Boost_THREADAPI "win32")' > '$(CMAKE_TOOLCHAIN_DIR)/$(PKG).cmake'

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -U__STRICT_ANSI__ -pedantic \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-boost.exe' \
        -DBOOST_THREAD_USE_LIB \
        -lboost_serialization-mt \
        -lboost_thread_win32-mt \
        -lboost_system-mt \
        -lboost_chrono-mt

    # test cmake
    mkdir '$(1).test-cmake'
    cd '$(1).test-cmake' && '$(TARGET)-cmake' \
        -DPKG=$(PKG) \
        -DPKG_VERSION=$($(PKG)_VERSION) \
        '$(PWD)/src/cmake/test'
    $(MAKE) -C '$(1).test-cmake' -j 1 install
endef
