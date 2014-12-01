# This file is part of MXE.
# See index.html for further information.

PKG             := boost
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.57.0
$(PKG)_CHECKSUM := e151557ae47afd1b43dc3fac46f8b04a8fe51c12
$(PKG)_SUBDIR   := boost_$(subst .,_,$($(PKG)_VERSION))
$(PKG)_FILE     := boost_$(subst .,_,$($(PKG)_VERSION)).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/boost/boost/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib bzip2 expat

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.boost.org/users/download/' | \
    $(SED) -n 's,.*/boost/\([0-9][^"/]*\)/".*,\1,p' | \
    grep -v beta | \
    head -1
endef

define $(PKG)_BUILD
    # old version appears to interfere
    rm -rf '$(PREFIX)/$(TARGET)/include/boost/'
    echo 'using gcc : : $(TARGET)-g++ : <rc>$(TARGET)-windres <archiver>$(TARGET)-ar <ranlib>$(TARGET)-ranlib ;' > '$(1)/user-config.jam'
    # compile boost jam
    cd '$(1)/tools/build/' && ./bootstrap.sh
    $(SED) -i 's, as , $(TARGET)-as ,g'   '$(1)/libs/context/build/Jamfile.v2'
    $(SED) -i 's, cpp , $(TARGET)-cpp ,g' '$(1)/libs/context/build/Jamfile.v2'
    cd '$(1)' && ./tools/build/b2 \
        -j '$(JOBS)' \
        --ignore-site-config \
        --user-config=user-config.jam \
        toolset=gcc \
        target-os=windows \
        threading=multi \
        link=$(if $(BUILD_STATIC),static,shared) \
        threadapi=win32 \
        --layout=tagged \
        --disable-icu \
        --without-context \
        --without-mpi \
        --without-python \
        --build-dir='$(1).build' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --exec-prefix='$(PREFIX)/$(TARGET)/bin' \
        --libdir='$(PREFIX)/$(TARGET)/lib' \
        --includedir='$(PREFIX)/$(TARGET)/include' \
        -sEXPAT_INCLUDE='$(PREFIX)/$(TARGET)/include' \
        -sEXPAT_LIBPATH='$(PREFIX)/$(TARGET)/lib' \
        stage install

    $(if $(BUILD_SHARED), \
        mv -fv '$(PREFIX)/$(TARGET)/lib/'libboost_*.dll '$(PREFIX)/$(TARGET)/bin/')

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -U__STRICT_ANSI__ -pedantic \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-boost.exe' \
        -DBOOST_THREAD_USE_LIB \
        -lboost_serialization-mt \
        -lboost_thread_win32-mt \
        -lboost_system-mt \
        -lboost_chrono-mt
endef
