# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := primesieve
$(PKG)_WEBSITE  := https://primesieve.org/
$(PKG)_DESCR    := Primesieve
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 12.8
$(PKG)_CHECKSUM := a0bf618a60a6b815c628196da9cb47e878e1414a06b4025acc5a1f9050223282
$(PKG)_GH_CONF  := kimwalisch/primesieve/tags, v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DBUILD_DOC=OFF \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_TESTS=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # compile test
    '$(TARGET)-g++' \
        -W -Wall -Werror -std=c++0x -fopenmp \
        '$(SOURCE_DIR)/examples/cpp/count_primes.cpp' \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' --cflags --libs $(PKG)`
endef
