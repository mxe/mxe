# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# libsndfile
PKG             := libsndfile
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.22
$(PKG)_CHECKSUM := 2bf823dcacf8ee78c56b8a877672753ee24d9d3b
$(PKG)_SUBDIR   := libsndfile-$($(PKG)_VERSION)
$(PKG)_FILE     := libsndfile-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.mega-nerd.com/libsndfile/
$(PKG)_URL      := http://www.mega-nerd.com/libsndfile/files/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc sqlite flac ogg vorbis

define $(PKG)_UPDATE
    wget -q -O- 'http://www.mega-nerd.com/libsndfile/' | \
    grep '<META NAME="Version"' | \
    $(SED) -n 's,.*CONTENT="libsndfile-\([0-9][^"]*\)">.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-sqlite \
        --enable-external-libs \
        --disable-octave \
        --disable-alsa
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS= html_DATA=
endef
