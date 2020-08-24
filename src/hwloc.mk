# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := hwloc
$(PKG)_WEBSITE  := https://www.open-mpi.org/projects/hwloc/
$(PKG)_DESCR    := Portable Hardware Locality (hwloc)
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.0
$(PKG)_CHECKSUM := ff6219c73e25d9930722e8f99ded0c72780a334aa525a8fee1ded0e953bec0fc
$(PKG)_GH_CONF  := open-mpi/hwloc/tags, hwloc-
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && ./autogen.sh
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --disable-gl \
        --disable-libudev \
        --disable-cuda \
        --disable-nvml \
        --disable-opencl \
        --disable-pci \
        --disable-io \
        --disable-libxml2 \
        --disable-cairo \
        CONFIG_SHELL=$(SHELL)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(PWD)/src/$(PKG)-test.c' -o '$(PREFIX)/$(TARGET)/bin/test-hwloc.exe' \
        `'$(TARGET)-pkg-config' hwloc --cflags --libs`
endef
