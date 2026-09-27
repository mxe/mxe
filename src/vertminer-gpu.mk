# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := vertminer-gpu
$(PKG)_WEBSITE  := https://github.com/Bufius/vertminer-gpu
$(PKG)_DESCR    := GPU miner for vertcoin
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6419989
$(PKG)_CHECKSUM := 5552fc5bb41adcc2701196281c997b728f2653b065b961596e476bb16aaf36a1
$(PKG)_GH_CONF  := Bufius/vertminer-gpu/master
$(PKG)_DEPS     := gcc curl opencl-amd pthreads

define $(PKG)_BUILD
    # doesn't seem to support out-of-source builds
    cd '$(SOURCE_DIR)' && autoreconf -fi
    cd '$(SOURCE_DIR)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-scrypt \
        --disable-adl \
        --without-curses \
        --enable-opencl \
        CFLAGS="`'$(TARGET)-pkg-config' libcurl --cflags`"
    $(MAKE) -C '$(SOURCE_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(SOURCE_DIR)' -j 1 install
endef
