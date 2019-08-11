# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := fluidsynth
$(PKG)_WEBSITE  := http://fluidsynth.org/
$(PKG)_DESCR    := FluidSynth - a free software synthesizer based on the SoundFont 2 specifications
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.5
$(PKG)_CHECKSUM := 69b244512883491e7e66b4d0151c61a0d6d867d4d2828c732563be0f78abcc51
$(PKG)_GH_CONF  := FluidSynth/fluidsynth/tags,v
$(PKG)_DEPS     := cc glib

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/fluidsynth'
    $(INSTALL) -v '$(BUILD_DIR)/include/fluidsynth.h'    '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -v '$(BUILD_DIR)/include/fluidsynth/'*.h  '$(PREFIX)/$(TARGET)/include/fluidsynth/'
    $(INSTALL) -v '$(SOURCE_DIR)/include/fluidsynth/'*.h '$(PREFIX)/$(TARGET)/include/fluidsynth/'
    $(INSTALL) -v '$(BUILD_DIR)/fluidsynth.pc'           '$(PREFIX)/$(TARGET)/lib/pkgconfig/' 
    $(INSTALL) -v '$(BUILD_DIR)/src/libfluidsynth.a' '$(PREFIX)/$(TARGET)/lib/'
    $(if $(BUILD_SHARED),\
    $(INSTALL) -m755 -v '$(BUILD_DIR)/src/libfluidsynth.dll.a' '$(PREFIX)/$(TARGET)/bin/')

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-fluidsynth.exe' \
        `'$(TARGET)-pkg-config' --cflags --libs fluidsynth` \
        `'$(TARGET)-pkg-config' --cflags --libs glib-2.0`
endef
