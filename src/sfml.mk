# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sfml
$(PKG)_WEBSITE  := https://www.sfml-dev.org/
$(PKG)_DESCR    := SFML
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.2
$(PKG)_CHECKSUM := 8ba04f6fde6a7b42527d69742c49da2ac529354f71f553409f9f821d618de4b6
$(PKG)_SUBDIR   := SFML-$($(PKG)_VERSION)
$(PKG)_FILE     := SFML-$($(PKG)_VERSION)-sources.zip
$(PKG)_URL      := https://sfml-dev.org/download/sfml/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc freetype glew jpeg libsndfile openal

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.sfml-dev.org/download.php' | \
    $(SED) -n 's,.*download/sfml/\([^"]\+\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && '$(TARGET)-cmake' .. \
        -DSFML_BUILD_EXAMPLES=FALSE \
        -DSFML_BUILD_DOC=FALSE

    # build and install libs
    $(MAKE) -C '$(1)/build/src/SFML' -j '$(JOBS)' install VERBOSE=1
    # install headers
    '$(TARGET)-cmake' -DCOMPONENT=devel -P '$(1)/build/cmake_install.cmake'

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
