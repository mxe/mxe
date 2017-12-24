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
$(PKG)_DEPS     := cc fftw libsamplerate qtbase

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, lastfm/liblastfm)
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_WITH_QT4=OFF

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
     echo 'Requires: Qt5Core Qt5Network Qt5Xml'; \
     echo 'Libs: -L$${libdir} -llastfm5'; \
     echo 'Cflags: -I$${includedir}';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG)5.pc'

    $(TARGET)-g++ \
        -W -Wall -Werror -std=c++11 -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `$(TARGET)-pkg-config $(PKG)5 --cflags --libs`
endef

$(PKG)_BUILD_STATIC =
