# This file is part of MXE.
# See index.html for further information.

PKG             := x265
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8
$(PKG)_CHECKSUM := d41a3f0cc06dfc3967f6c47f458cb30b6aaa518f86c56c147946395bfe22b6f2
$(PKG)_SUBDIR   := x265_$($(PKG)_VERSION)
$(PKG)_FILE     := x265_$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.videolan.org/pub/videolan/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc cmake yasm

define $(PKG)_UPDATE
    $(WGET) -q -O- https://ftp.videolan.org/pub/videolan/x265/ | \
    $(SED) -n 's,.*">x265_\([0-9][^<]*\)\.t.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && mkdir -p 8bit 10bit 12bit

    # 12 bit
    test '$(TARGET)' = 'x86_64-w64-mingw32.static' && X265_ASM=ON || X265_ASM=OFF; \
    cd '$(1)/12bit' && cmake ../source \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DHIGH_BIT_DEPTH=ON \
        -DEXPORT_C_API=OFF \
        -DENABLE_SHARED=OFF \
        -DENABLE_ASSEMBLY=$$X265_ASM \
        -DENABLE_CLI=OFF \
        -DMAIN12=ON
    $(MAKE) -C '$(1)/12bit' -j '$(JOBS)'
    cp '$(1)/12bit/libx265.a' '$(1)/8bit/libx265_main12.a'

    # 10 bit
    test '$(TARGET)' = 'x86_64-w64-mingw32.static' && X265_ASM=ON || X265_ASM=OFF; \
    cd '$(1)/10bit' && cmake ../source \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DHIGH_BIT_DEPTH=ON \
        -DEXPORT_C_API=OFF \
        -DENABLE_SHARED=OFF \
        -DENABLE_ASSEMBLY=$$X265_ASM \
        -DENABLE_CLI=OFF
    $(MAKE) -C '$(1)/10bit' -j '$(JOBS)'
    cp '$(1)/10bit/libx265.a' '$(1)/8bit/libx265_main10.a'

    # 8bit
    test '$(TARGET)' = 'x86_64-w64-mingw32.static' && X265_ASM=ON || X265_ASM=OFF; \
    cd '$(1)/8bit' && cmake ../source \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DENABLE_SHARED=OFF \
        -DENABLE_ASSEMBLY=$$X265_ASM \
        -DEXTRA_LIB="x265_main10.a;x265_main12.a" \
        -DEXTRA_LINK_FLAGS=-L. \
        -DLINKED_10BIT=ON \
        -DLINKED_12BIT=ON

    $(MAKE) -C '$(1)/8bit' -j '$(JOBS)' install
    $(INSTALL) '$(1)/8bit/libx265_main12.a' '$(PREFIX)/$(TARGET)/lib/libx265_main12.a'
    $(INSTALL) '$(1)/8bit/libx265_main10.a' '$(PREFIX)/$(TARGET)/lib/libx265_main10.a'
    $(SED) -i 's|-lx265|-lx265 -lx265_main10 -lx265_main12|' '$(PREFIX)/$(TARGET)/lib/pkgconfig/x265.pc'
endef

$(PKG)_BUILD_SHARED =

