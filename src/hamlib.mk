# This file is part of MXE. See LICENSE.md for licensing information.
# visit http://hamlib.org or https://github.com/N0NB/hamlib
# 2016-12-24 Lars Holger Engelhard DL5RCW

PKG             := hamlib
$(PKG)_WEBSITE  := http://www.hamlib.org/
$(PKG)_DESCR    := HamLib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.1
$(PKG)_CHECKSUM := 3fec97ea326d02aa8f35834c4af34194a3f544e6212f391397d788c566b44e32
$(PKG)_SUBDIR   := hamlib-$($(PKG)_VERSION)
$(PKG)_FILE     := Hamlib-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/hamlib/hamlib/$($(PKG)_VERSION)/hamlib-$($(PKG)_VERSION).tar.gz
$(PKG)_URL_2    := https://github.com/N0NB/$(PKG)/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc libltdl libusb1 libxml2 pthreads

# grabbing version from sourceforge
# prefered by Nate N0NB
define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/hamlib/files/hamlib/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

## grabbing version from github via MXE
#define $(PKG)_UPDATE
#    $(call MXE_GET_GITHUB_TAGS, N0NB/hamlib)
#endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --with-included-ltdl \
        --disable-winradio
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' || $(MAKE) -C '$(BUILD_DIR)' -j 1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT)

    # create pkg-config files
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $(hamlib_VERSION)'; \
     echo 'Description: $(PKG)'; \
     echo 'Cflags: -DHAMLIB_LIB'; \
     echo 'Libs: -lhamlib -lpthread -lws2_32';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(PWD)/src/$(PKG)-test.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' --cflags --libs hamlib pthreads`
endef
