# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := fluidsynth
$(PKG)_WEBSITE  := http://fluidsynth.org/
$(PKG)_DESCR    := FluidSynth - a free software synthesizer based on the SoundFont 2 specifications
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.2
$(PKG)_CHECKSUM := 9206d83b8d2f7e1ec259ee01e943071de67e419aabe142b51312f8edb39c5503
$(PKG)_GH_CONF  := FluidSynth/fluidsynth/tags,v
$(PKG)_DEPS     := cc dbus glib jack libsndfile mman-win32 portaudio readline

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -Dbuild-bins=OFF \
        -Dbuild-docs=OFF \
        -Dbuild-tests=OFF \
        -Denable-dbus=ON \
        -Denable-jack=$(CMAKE_SHARED_BOOL) \
        -Denable-libsndfile=ON \
        -Denable-portaudio=ON \
        -Denable-readline=ON \
        -DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        -DBUILD_STATIC_LIBS=$(CMAKE_STATIC_BOOL) \
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
