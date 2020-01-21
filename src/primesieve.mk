# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := primesieve
$(PKG)_WEBSITE  := https://primesieve.org/
$(PKG)_DESCR    := Primesieve
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.4
$(PKG)_CHECKSUM := ff9b9e8c6ca3b5c642f9a334cc399dd55830a8d9c25afd066528aa2040032399
$(PKG)_GH_CONF  := kimwalisch/primesieve/tags, v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DBUILD_DOC=OFF \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_TESTS=OFF \
        -DCMAKE_CXX_FLAGS='-D_WIN32_WINNT=0x0601'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # compile test
    '$(TARGET)-g++' \
        -W -Wall -Werror -std=c++0x -fopenmp \
        '$(SOURCE_DIR)/examples/cpp/count_primes.cpp' \
        -o '$(PREFIX)/$(TARGET)/bin/test-fluidsynth.exe' \
        `'$(TARGET)-pkg-config' --cflags --libs $(PKG)`
endef
