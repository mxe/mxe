# This file is part of MXE.
# See index.html for further information.

PKG             := gtkglextmm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.0
$(PKG)_CHECKSUM := 5cd489e07517a88262cd6050f723227664e82996
$(PKG)_SUBDIR   := gtkglextmm-$($(PKG)_VERSION)
$(PKG)_FILE     := gtkglextmm-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/gtkglext/gtkglextmm/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gtkglext gtkmm2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.gnome.org/cgit/gtkglextmm/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=\\([0-9][^']*\\)'.*,\\1,p" | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared
    $(MAKE) -C '$(1)' -j '$(JOBS)' install \
        bin_PROGRAMS= \
        sbin_PROGRAMS= \
        noinst_PROGRAMS= \
        INFO_DEPS=

    '$(TARGET)-g++' \
        -W -Wall -Werror -pedantic -std=c++0x \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-gtkglextmm.exe' \
        `'$(TARGET)-pkg-config' gtkglextmm-1.2 --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
