# This file is part of MXE.
# See index.html for further information.

PKG             := gnuplot
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 1ea21a628223159b0297ae65fe8293afd5aab3c0
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := gnuplot-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://sourceforge.net/projects/gnuplot/files/gnuplot/4.6.1/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package gnuplot.' >&2;
    echo $(gnuplot_VERSION)
endef

define $(PKG)_BUILD
    make -C '$(1)/config/mingw' CC='$(TARGET)-gcc' CXX='$(TARGET)-g++' RC='$(TARGET)-windres' -j '$(JOBS)' TARGET=gnuplot.exe gnuplot.exe
    make -C '$(1)/config/mingw' CC='$(TARGET)-gcc' CXX='$(TARGET)-g++' RC='$(TARGET)-windres' -j '$(JOBS)' TARGET=wgnuplot.exe wgnuplot.exe
    make -C '$(1)/config/mingw' CC='$(TARGET)-gcc' CXX='$(TARGET)-g++' RC='$(TARGET)-windres' -j '$(JOBS)' wgnuplot.mnu

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin'
    $(INSTALL) -m755 '$(1)/config/mingw/gnuplot.exe' '$(PREFIX)/$(TARGET)/bin/'
    $(INSTALL) -m755 '$(1)/config/mingw/wgnuplot.exe' '$(PREFIX)/$(TARGET)/bin/'
    $(INSTALL) -m644 '$(1)/config/mingw/wgnuplot.mnu' '$(PREFIX)/$(TARGET)/bin/'

endef
