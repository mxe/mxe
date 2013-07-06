# This file is part of MXE.
# See index.html for further information.

PKG             := sfml
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := ff8cf290f49e1a1d8517a4a344e9214139da462f
$(PKG)_SUBDIR   := SFML-$($(PKG)_VERSION)
$(PKG)_FILE     := SFML-$($(PKG)_VERSION)-sources.zip
$(PKG)_URL      := http://sfml-dev.org/download/sfml/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc freetype glew jpeg openal libsndfile

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.sfml-dev.org/download.php' | \
    grep 'download/sfml/' | \
    $(SED) -n 's,.*\([0-9.]\+\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'

    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install VERBOSE=1
	
    '$(TARGET)-g++' \
        -W -Wall -Werror \
		-DSFML_STATIC -DAL_LIBTYPE_STATIC \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-sfml.exe' \
		-lsfml-audio-s -lsfml-network-s -lsfml-graphics-s -lsfml-window-s -lsfml-system-s \
		-lGLEW -lopengl32 -lgdi32 -lOpenAL32 -lwinmm -luuid -lole32 -ljpeg \
		-lsndfile -lws2_32 -lfreetype -lFLAC -lvorbisenc -lvorbis -logg -lm -lpng -lz -lbz2
		
endef
