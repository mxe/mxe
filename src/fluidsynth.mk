# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := fluidsynth
$(PKG)_WEBSITE  := http://fluidsynth.org/
$(PKG)_DESCR    := FluidSynth - a free software synthesizer based on the SoundFont 2 specifications
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.7
$(PKG)_CHECKSUM := b68876d24c7fb34575ffa389bcfe8e61a24f1cf1da8ec6c3b2053efde98d0320
$(PKG)_GH_CONF  := FluidSynth/fluidsynth/tags,v
$(PKG)_DEPS     := cc dbus glib jack libsndfile mman-win32 portaudio readline

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -Dbuild-bins=OFF \
        -Dbuild-docs=OFF \
        -Dbuild-tests=OFF \
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
