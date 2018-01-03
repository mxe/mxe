# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sox
$(PKG)_WEBSITE  := https://sox.sourceforge.io/
$(PKG)_DESCR    := SoX
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 14.4.2
$(PKG)_CHECKSUM := b45f598643ffbd8e363ff24d61166ccec4836fea6d3888881b8df53e3bb55f6c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc file flac lame libltdl libmad libpng libsndfile \
                   opencore-amr opus twolame vorbis wavpack

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/sox/files/sox/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # set pkg-config cflags and libs
    $(SED) -i 's,^\(Cflags:.*\),\1 -fopenmp,' '$(1)/sox.pc.in'
    $(SED) -i '/Libs.private/d'               '$(1)/sox.pc.in'
    echo Libs.private: @MAGIC_LIBS@ \
        `grep sox_LDADD '$(1)/src/optional-fmts.am' | \
         $(SED) 's, sox_LDADD += ,,g' | tr -d '\n'` @LIBS@ >>'$(1)/sox.pc.in'

    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --enable-static \
        --disable-debug \
        --with-libltdl \
        --with-magic \
        --with-png \
        --with-ladspa \
        --with-amrwb \
        --with-amrnb \
        --with-flac \
        --with-oggvorbis \
        --with-sndfile \
        --with-wavpack \
        --with-mad \
        --without-id3tag \
        --with-lame \
        --with-twolame \
        --with-waveaudio \
        --without-alsa \
        --without-ao \
        --without-coreaudio \
        --without-oss \
        --without-pulseaudio \
        --without-sndio \
        --without-sunaudio \
        LIBS='-lshlwapi -lgnurx'

    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= EXTRA_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-sox.exe' \
        `'$(TARGET)-pkg-config' sox --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
