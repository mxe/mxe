# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := termcap
$(PKG)_WEBSITE  := https://www.gnu.org/software/termutils/
$(PKG)_DESCR    := Termcap
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.1
$(PKG)_CHECKSUM := 91a0e22e5387ca4467b5bcb18edf1c51b930262fd466d5fda396dd9d26719100
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/termcap/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/termcap/' | \
    grep 'termcap-' | \
    $(SED) -n 's,.*termcap-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # configure script is ancient and lacks cross-compiling support
    cd '$(SOURCE_DIR)' && autoreconf -fi
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' \
        AR='$(TARGET)-ar' \
        oldincludedir= \
        install

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: $($(PKG)_DESCR)'; \
     echo 'Requires:'; \
     echo 'Libs: -l$(PKG)'; \
     echo 'Cflags.private:';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    # no shared support in configure/Makefile
    $(if $(BUILD_SHARED), \
        $(MAKE_SHARED_FROM_STATIC) '$(BUILD_DIR)/libtermcap.a')
endef
