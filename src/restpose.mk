# This file is part of MXE.
# See index.html for further information.

PKG             := restpose
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 3649d5a81a3ea4d5a22951517d262ccac6058a97
$(PKG)_SUBDIR   := restpose-$($(PKG)_VERSION)
$(PKG)_FILE     := restpose-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://cloud.github.com/downloads/$(PKG)/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc xapian-core plibc libiberty

define $(PKG)_BUILD
    cd '$(1)' && \
    ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-static \
	--disable-shared \
	CXXFLAGS=-D__MSVCRT_VERSION__=0x0601 \
	LIBS="-lwsock32 -lole32 -liberty"
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
