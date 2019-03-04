PKG             := fluidsynth
$(PKG)_WEBSITE  := http://www.fluidsynth.org
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.6
$(PKG)_CHECKSUM := 50853391d9ebeda9b4db787efb23f98b1e26b7296dd2bb5d0d96b5bccee2171c
$(PKG)_SUBDIR   := fluidsynth
$(PKG)_FILE     := fluidsynth-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://downloads.sourceforge.net/project/fluidsynth/fluidsynth-1.1.6/fluidsynth-1.1.6.tar.gz
$(PKG)_DEPS     := gcc portaudio

define $(PKG)_UPDATE
    wget -q -O- 'http://iweb.dl.sourceforge.net/project/fluidsynth/fluidsynth-1.1.6/' | \
    $(SED) -n 's,.*zziplib-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)-1.1.6.build'
    cd '$(1)-1.1.6.build' && '$(TARGET)-cmake' \
        -DBUILD_TESTING=FALSE \
        '$(1)-1.1.6'
    $(MAKE) -C '$(1)-1.1.6.build' install
endef

#define $(PKG)_BUILD
#    cd '$(1)-1.1.6' && \
#    cmake -Denable-dbus=no -Denable-readline=no . -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'
#    $(MAKE) -C '$(1)' -j '$(JOBS)' install
#endef

#
#    cmake -DBUILD_SHARED_LIBS=OFF -Denable-dbus=no -Denable-readline=no . -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'
#define $(PKG)_BUILD
#    cd '$(1)/' && ./configure \
#        --host='$(TARGET)' \
#        --disable-shared \
#	--enable-static \
#        --prefix='$(PREFIX)/$(TARGET)' \
#	--disable-libsndfile-support \
#	--with-pic \
#	--disable-alsa-support \
-#	--enable-portaudio-support \
#	--disable-oss-support \
#	--disable-midishare \
#	--disable-jack-support \
#	--disable-coreaudio \
#	--disable-lash \
#	--disable-ladcca \
#	--disable-dbus-support \
#	--disable-realine \
#        CONFIG_SHELL=$(SHELL)
#    $(MAKE) -C '$(1)/' -j '$(JOBS)' install
#endef
