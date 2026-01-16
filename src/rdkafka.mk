# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := rdkafka
$(PKG)_WEBSITE  := https://github.com/confluentinc/librdkafka
$(PKG)_DESCR    := Apache Kafka C/C++ library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.12.1
$(PKG)_CHECKSUM := ec103fa05cb0f251e375f6ea0b6112cfc9d0acd977dc5b69fdc54242ba38a16f
$(PKG)_GH_CONF  := confluentinc/librdkafka/releases,v
$(PKG)_SUBDIR   := librdkafka-$($(PKG)_VERSION)
$(PKG)_FILE     := v$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/confluentinc/librdkafka/archive/refs/tags/$($(PKG)_FILE)
$(PKG)_DEPS     := cc zlib openssl zstd curl cyrus-sasl lz4 pthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/confluentinc/librdkafka/releases' | \
    $(SED) -n 's,.*releases/tag/v\([0-9][^"]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && \
        PKG_CONFIG='$(TARGET)-pkg-config' \
        PKG_CONFIG_PATH='$(PREFIX)/$(TARGET)/lib/pkgconfig' \
        ./configure \
        --host='$(TARGET)' \
        --build='$(BUILD)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-ssl \
        --enable-zstd \
        --enable-lz4-ext \
        --enable-sasl \
        --disable-curl \
        --enable-static \
        --disable-shared
    # Build only library, skip examples to avoid linking issues
    $(MAKE) -C '$(SOURCE_DIR)/src' -j '$(JOBS)'
    $(MAKE) -C '$(SOURCE_DIR)/src-cpp' -j '$(JOBS)'
    $(MAKE) -C '$(SOURCE_DIR)/src' -j 1 install
    $(MAKE) -C '$(SOURCE_DIR)/src-cpp' -j 1 install

    # Create pkg-config link
    ln -sf '$(PREFIX)/$(TARGET)/lib/pkgconfig/rdkafka.pc' '$(PREFIX)/$(TARGET)/lib/pkgconfig/librdkafka.pc' || true
endef
