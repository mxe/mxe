# This file is part of MXE.
# See index.html for further information.

# sox
PKG             := sox
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 71f05afc51e3d9b03376b2f98fd452d3a274d595
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc flac lame libgomp libmad libsndfile vorbis wavpack

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/sox/files/sox/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # set pkg-config cflags and libs
    $(SED) -i 's,^\(Cflags:.*\),\1 -fopenmp,' '$(1)/sox.pc.in'
    $(SED) -i '/Libs.private/d'               '$(1)/sox.pc.in'
    echo Libs.private: `grep sox_LDADD '$(1)/src/optional-fmts.am' | \
    $(SED) 's, sox_LDADD += ,,g' | tr -d '\n'` >>'$(1)/sox.pc.in'

    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --enable-static \
        --disable-debug \
        --without-magic \
        --without-png \
        --without-ladspa \
        --without-amrwb \
        --without-amrnb \
        --without-ffmpeg \
        --with-flac \
        --with-oggvorbis \
        --with-sndfile \
        --with-wavpack \
        --with-mad \
        --without-id3tag \
        --with-lame \
        --with-waveaudio \
        --without-alsa \
        --without-ao \
        --without-coreaudio \
        --without-oss \
        --without-pulseaudio \
        --without-sndio \
        --without-sunaudio

    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= EXTRA_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-sox.exe' \
        `'$(TARGET)-pkg-config' sox --cflags --libs`
endef

# to enable flac with mingw-w64, use the following sed replacement
# it works but needs more investigation
# $(SED) -i 's,\(#if defined(__MINGW32__)\),\1 \&\& !defined\(__MINGW64_VERSION_MAJOR\),' $(1)/src/flac.c

$(PKG)_BUILD_x86_64-w64-mingw32 = $(subst --with-flac,--without-flac,$($(PKG)_BUILD))
$(PKG)_BUILD_i686-w64-mingw32 = $(subst --with-flac,--without-flac,$($(PKG)_BUILD))
