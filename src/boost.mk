# This file is part of mingw-cross-env.
# See doc/index.html or doc/README for further information.

# Boost C++ Library
PKG             := boost
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1_41_0
$(PKG)_CHECKSUM := 31134e28866b90c39ca4a903c263e036bb25550c
$(PKG)_SUBDIR   := boost_$($(PKG)_VERSION)
$(PKG)_FILE     := boost_$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.boost.org/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/boost/boost/$(subst _,.,$($(PKG)_VERSION))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib bzip2 expat

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/boost/files/boost/) | \
    $(SED) -n 's,.*boost_\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v beta | \
    tail -1
endef

define $(PKG)_BUILD
    echo 'using gcc : : $(TARGET)-g++ : ;' > '$(1)/user-config.jam'
    # make the build script generate .a library files instead of .lib
    $(SED) 's,<target-os>windows : lib ;,<target-os>windows : a ;,' -i '$(1)/tools/build/v2/tools/types/lib.jam'
    # compile boost jam
    cd '$(1)/tools/jam/src' && ./build.sh
    cd '$(1)' && tools/jam/src/bin.*/bjam \
        -j '$(JOBS)' \
        --ignore-site-config \
        --user-config=user-config.jam \
        target-os=windows \
        threading=multi \
        link=static \
        threadapi=win32 \
        --layout=tagged \
        --without-mpi \
        --without-python \
        --prefix='$(PREFIX)/$(TARGET)' \
        --exec-prefix='$(PREFIX)/$(TARGET)/bin' \
        --libdir='$(PREFIX)/$(TARGET)/lib' \
        --includedir='$(PREFIX)/$(TARGET)/include' \
        -sEXPAT_INCLUDE='$(PREFIX)/$(TARGET)/include' \
        -sEXPAT_LIBPATH='$(PREFIX)/$(TARGET)/lib' \
        stage install
endef
