# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# GtkGLExtmm
PKG             := gtkglextmm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.0
$(PKG)_CHECKSUM := 5cd489e07517a88262cd6050f723227664e82996
$(PKG)_SUBDIR   := gtkglextmm-$($(PKG)_VERSION)
$(PKG)_FILE     := gtkglextmm-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://gtkglext.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/gtkglext/gtkglextmm/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gtkmm

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/cgit/gtkglextmm/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=\\([0-9][^']*\\)'.*,\\1,p" | \
    grep -v '1\.1\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared
    $(MAKE) -C '$(1)' -j '$(JOBS)' install \
        bin_PROGRAMS= \
        sbin_PROGRAMS= \
        noinst_PROGRAMS= \
        INFO_DEPS=

    '$(TARGET)-g++' \
        -W -Wall \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-$(TARGET).exe' \
        `'$(TARGET)-pkg-config' gtkglextmm-1.2 --cflags --libs` \
        -lwinspool -lcomctl32 -lcomdlg32 -ldnsapi
endef
