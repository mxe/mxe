# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libomemo-c
$(PKG)_WEBSITE  := https://github.com/dino/libomemo-c
$(PKG)_DESCR    := an implementation of Signal's ratcheting forward secrecy protocol in C
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.5.0
$(PKG)_CHECKSUM := 03195a24ef7a86c339cdf9069d7f7569ed511feaf55e853bfcb797d2698ba983
$(PKG)_GH_CONF  := dino/libomemo-c/tags,v
$(PKG)_DEPS     := cc pthreads

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DPKG_CONFIG_EXECUTABLE='$(PREFIX)/bin/$(TARGET)-pkg-config'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1

    '$(TARGET)-gcc' \
        -W -Wall -Werror -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-libomemo-c.exe' \
        `'$(TARGET)-pkg-config' libomemo-c --cflags --libs`
endef
