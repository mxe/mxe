# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := fluidsynth
$(PKG)_WEBSITE  := http://www.fluidsynth.org
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.0
$(PKG)_CHECKSUM := 63e62331292d495653e2d986783b9294af2e5b8f1c054a74fe6b4cc65cb0693e
$(PKG)_SUBDIR   := fluidsynth-$($(PKG)_VERSION)/
$(PKG)_FILE     := $($(PKG)_VERSION).tar.gz
$(PKG)_URL      := 'http://download.savannah.gnu.org/releases/fluid/fluidsynth-1.1.0.tar.gz'
$(PKG)_DEPS     := gcc glib portaudio libsndfile

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://download.savannah.gnu.org/releases/fluid/d?C=M;O=D' | \
    $(SED) -n 's,.*"v\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef


define $(PKG)_BUILD
    cd '$(1)' && ./autogen.sh 
    cd '$(1)' && ./configure \
      $(MXE_CONFIGURE_OPTS) \
      --disable-dbus-support \
      --disable-jack-support \
#      --disable-aufile-support \
      --disable-libsndfile-support 
#    LDFLAGS="-luuid -no-undefined"    
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

#    '$(TARGET)-gcc' \
#    -Wl,-Bstatic -lfluidsynth \
#        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-fluidsynth.exe'     	
endef
