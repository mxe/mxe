# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libfilezilla
$(PKG)_WEBSITE  := download.filezilla-project.org
$(PKG)_DESCR    := Small and modern C++ library, offering some basic functionality to build high-performing, platform-independent programs
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.12.0
$(PKG)_CHECKSUM := 0a58490c154961b3d1a9d5fe1d739de324ed650033c861725cb55c0e2b79ea93
$(PKG)_SUBDIR   := libfilezilla-$($(PKG)_VERSION)
$(PKG)_FILE     := libfilezilla-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://download.filezilla-project.org/libfilezilla/libfilezilla-$($(PKG)_VERSION).tar.bz2
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(call GET_LATEST_VERSION, http://download.filezilla-project.org/libfilezilla)
endef
# $(call GET_LATEST_VERSION, base url[, prefix, ext, filter, separator])
#  base url : required page returning list of versions
#               e.g https://ftp.gnu.org/gnu/libfoo
#  prefix   : segment before version
#               defaults to lastword of url with dash i.e. `libfoo-`
#  ext      : segment ending version - default `\.tar`
#  filter   : `grep -i` filter-out pattern - default alpha\|beta\|rc
#  separator: transform char to `.` - typically `_`

# test with make check-update-package-libfilezilla and delete comments

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install \
        bin_PROGRAMS= \
        sbin_PROGRAMS= \
        noinst_PROGRAMS=

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: $($(PKG)_DESCR)'; \
     echo 'Requires:'; \
     echo 'Libs: -lfilezilla'; \
     echo 'Cflags.private:';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
