# Boost C++ Library

PKG             := boost
$(PKG)_VERSION  := 1_38_0
$(PKG)_CHECKSUM := b32ff8133b0a38a74553c0d33cb1d70b3ce2d8f1
$(PKG)_SUBDIR   := boost_$($(PKG)_VERSION)
$(PKG)_FILE     := boost_$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.boost.org/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/boost/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib bzip2 expat

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/boost/files/boost/) | \
    $(SED) -n 's,.*boost_\([0-9][^>]*\)\.tar.*,\1,p' | \
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
        --user-config=user-config.jam \
        target-os=windows \
        threading=multi \
        link=static \
        threadapi=win32 \
        --layout=system \
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
