# This file is part of MXE.
# See index.html for further information.

PKG             := libsndfile
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.25
$(PKG)_CHECKSUM := e95d9fca57f7ddace9f197071cbcfb92fa16748e
$(PKG)_SUBDIR   := libsndfile-$($(PKG)_VERSION)
$(PKG)_FILE     := libsndfile-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.mega-nerd.com/libsndfile/files/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc sqlite flac ogg vorbis

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.mega-nerd.com/libsndfile/' | \
    grep '<META NAME="Version"' | \
    $(SED) -n 's,.*CONTENT="libsndfile-\([0-9][^"]*\)">.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-sqlite \
        --enable-external-libs \
        --disable-octave \
        --disable-alsa \
        --disable-shave \
        LIBS="`$(TARGET)-pkg-config --libs vorbis ogg`"
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS= html_DATA=
endef
