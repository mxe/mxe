# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := liblastfm
$(PKG)_WEBSITE  := https://github.com/lastfm/liblastfm
$(PKG)_DESCR    := A Qt C++ library for the Last.fm webservices
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.9
$(PKG)_CHECKSUM := 5276b5fe00932479ce6fe370ba3213f3ab842d70a7d55e4bead6e26738425f7b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/lastfm/$(PKG)/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc fftw libsamplerate qtbase

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, lastfm/liblastfm)
endef

define $(PKG)_BUILD_COMMON
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_DEMOS=OFF \
        -DBUILD_TESTS=OFF \
        -DBUILD_WITH_QT4=@lastfm_use_qt4@

    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'prefix=$(PREFIX)/$(TARGET)'; \
     echo 'exec_prefix=$${prefix}'; \
     echo 'libdir=$${exec_prefix}/lib'; \
     echo 'includedir=$${prefix}/include'; \
     echo ''; \
     echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: A Qt C++ library for the Last.fm webservices'; \
     echo 'Requires: Qt@lastfm_version_suffix@Core Qt@lastfm_version_suffix@Network Qt@lastfm_version_suffix@Xml'; \
     echo 'Libs: -L$${libdir} -llastfm@lastfm_version_suffix@'; \
     echo 'Cflags: -I$${includedir}'; \
     echo 'Cflags.private: -DLASTFM_LIB_STATIC'; \
    ) > '$(PREFIX)/$(TARGET)/lib/pkgconfig/liblastfm@lastfm_version_suffix@.pc'

    $(TARGET)-g++ \
        -W -Wall -Werror -std=c++11 -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `$(TARGET)-pkg-config liblastfm@lastfm_version_suffix@ --cflags --libs`
endef

$(PKG)_BUILD = $(subst @lastfm_use_qt4@,OFF, \
               $(subst @lastfm_version_suffix@,5, \
               $($(PKG)_BUILD_COMMON)))
