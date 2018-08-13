# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sfml
$(PKG)_WEBSITE  := https://www.sfml-dev.org/
$(PKG)_DESCR    := SFML
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.2
$(PKG)_CHECKSUM := cf268fb487e4048c85e5b2f53d62596854762c98cba1c1b61ccd91f78253ef4b
$(PKG)_GH_CONF  := SFML/SFML/tags
$(PKG)_DEPS     := cc freetype glew jpeg libsndfile openal

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DSFML_BUILD_EXAMPLES=FALSE \
        -DSFML_BUILD_DOC=FALSE

    # build and install libs
    $(MAKE) -C '$(BUILD_DIR)/src/SFML' -j '$(JOBS)' install VERBOSE=1
    # install headers
    '$(TARGET)-cmake' -DCOMPONENT=devel -P '$(BUILD_DIR)/cmake_install.cmake'

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: sfml'; \
     echo 'Version: 0'; \
     echo 'Description: sfml'; \
     echo 'Requires: freetype2 glew openal sndfile vorbisenc vorbisfile'; \
     echo 'Cflags: -DSFML_STATIC'; \
     echo 'Libs: -lsfml-audio-s -lsfml-network-s -lsfml-graphics-s -lsfml-window-s -lsfml-system-s'; \
     echo 'Libs.private: -ljpeg -lws2_32 -lgdi32';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/sfml.pc'

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-sfml.exe' \
        `$(TARGET)-pkg-config --cflags --libs sfml`
endef

$(PKG)_BUILD_SHARED =
