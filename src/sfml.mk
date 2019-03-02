# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sfml
$(PKG)_WEBSITE  := https://www.sfml-dev.org/
$(PKG)_DESCR    := SFML
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5.1
$(PKG)_CHECKSUM := 438c91a917cc8aa19e82c6f59f8714da353c488584a007d401efac8368e1c785
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
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: sfml'; \
     echo 'Requires: freetype2 glew openal sndfile vorbisenc vorbisfile'; \
     echo 'Cflags.private: -DSFML_STATIC'; \
     echo 'Libs: $(addprefix -lsfml-,$(addsuffix $(if $(BUILD_STATIC),-s), audio network graphics window system))'; \
     echo 'Libs.private: -ljpeg -lws2_32 -lgdi32';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/sfml.pc'
    cat '$(PREFIX)/$(TARGET)/lib/pkgconfig/sfml.pc'

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-sfml.exe' \
        `$(TARGET)-pkg-config --cflags --libs sfml`
endef
