# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := openal
$(PKG)_WEBSITE  := https://openal-soft.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.19.1
$(PKG)_CHECKSUM := 9f3536ab2bb7781dbafabc6a61e0b34b17edd16bd6c2eaf2ae71bc63078f98c7
$(PKG)_GH_CONF  := kcat/openal-soft/releases,openal-soft-
$(PKG)_DEPS     := cc portaudio

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://openal-soft.org/openal-releases/?C=M;O=D' | \
    $(SED) -n 's,.*"openal-soft-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DALSOFT_EXAMPLES=FALSE \
        -DALSOFT_TESTS=FALSE \
        -DALSOFT_UTILS=FALSE
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' || $(MAKE) -C '$(BUILD_DIR)' -j 1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-openal.exe' \
        `'$(TARGET)-pkg-config' openal --cflags --libs`
endef
