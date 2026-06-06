# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := fluidsynth
$(PKG)_WEBSITE  := http://fluidsynth.org/
$(PKG)_DESCR    := FluidSynth - a free software synthesizer based on the SoundFont 2 specifications
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5.4
$(PKG)_CHECKSUM := 72f5720328fe44e2e5c67813885f0a6b4b004d048bd2eeeb0c0064074ebff530
$(PKG)_GH_CONF  := FluidSynth/fluidsynth/tags,v
$(PKG)_DEPS     := cc dbus gcem glib jack libsndfile mman-win32 portaudio readline

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -Denable-dbus=ON \
        -Denable-jack=$(CMAKE SHARED_BOOL) \
        -Denable-libsndfile=ON \
        -Denable-portaudio=ON \
        -Denable-readline=ON \
        $($(PKG)_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        -Wl,--allow-multiple-definition \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-fluidsynth.exe' \
        `'$(TARGET)-pkg-config' --cflags --libs fluidsynth`
endef
