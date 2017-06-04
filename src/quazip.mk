# This file is part of MXE.
# See index.html for further information.
PKG             := quazip
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.7.3
$(PKG)_CHECKSUM := 2ad4f354746e8260d46036cde1496c223ec79765041ea28eb920ced015e269b5
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qtbase

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/quazip/files/quazip/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef


define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' \
    $(if $(BUILD_STATIC), CONFIG\+=staticlib) \
    PREFIX=$(PREFIX)/$(TARGET)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(if $(BUILD_STATIC), \
        echo 'Cflags.private: -DQUAZIP_STATIC' >> $(1)/quazip/lib/pkgconfig/quazip.pc)
    $(MAKE) -C '$(1)' -j 1 install

    # qmake insists to install the static .a
    # even when building shared lib
    $(if $(BUILD_SHARED), \
        rm -f $(PREFIX)/$(TARGET)/bin/libquazip.a)

    '$(TARGET)-g++' \
        -W -Wall -Werror -std=c++11 -pedantic \
        '$(TOP_DIR)/src/$(PKG)-test.cpp' \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG)-pkgconfig.exe' \
        `'$(TARGET)-pkg-config' quazip --cflags --libs`
endef
