# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := liblastfm_qt4
$(PKG)_WEBSITE  := https://github.com/lastfm/liblastfm
$(PKG)_DESCR    := A Qt C++ library for the Last.fm webservices
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.9
$(PKG)_CHECKSUM := 5276b5fe00932479ce6fe370ba3213f3ab842d70a7d55e4bead6e26738425f7b
$(PKG)_GH_CONF  := lastfm/liblastfm/tags
$(PKG)_DEPS     := cc fftw libsamplerate qt

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_WITH_QT4=ON

    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'prefix=$(PREFIX)/$(TARGET)'; \
     echo 'exec_prefix=$${prefix}'; \
     echo 'libdir=$${exec_prefix}/lib'; \
     echo 'includedir=$${prefix}/include'; \
     echo ''; \
     echo 'Name: liblastfm'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: A Qt C++ library for the Last.fm webservices'; \
     echo 'Requires: QtCore QtNetwork QtXml'; \
     echo 'Libs: -L$${libdir} -llastfm'; \
     echo 'Cflags: -I$${includedir}';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/liblastfm.pc'

    $(TARGET)-g++ \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `$(TARGET)-pkg-config liblastfm --cflags --libs`
endef

$(PKG)_BUILD_STATIC =
