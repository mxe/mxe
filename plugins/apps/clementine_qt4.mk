# This file is part of MXE. See LICENSE.md for licensing information.

# lconvert and lupdate are not provided by MXE for Qt4,
# so for Debian/Ubuntu you need install packages qt4-linguist-tools
# (this package contains lupdate and lrelease) and qt4-dev-tools
# (this package contains lconvert):
# apt-get install qt4-linguist-tools qt4-dev-tools
# Or you may use lupdate, lrelease, lconvert from Qt5:
# apt-get install qttools5-dev-tools

PKG             := clementine_qt4
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.1
$(PKG)_CHECKSUM := f885931a9ab7c88607d07b50c64fcce46fc05f13dd2c0a04188c94eff938f37c
$(PKG)_SUBDIR   := Clementine-$($(PKG)_VERSION)
$(PKG)_FILE     := clementine-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/clementine-player/clementine/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := https://www.clementine-player.org/
$(PKG)_OWNER    := https://github.com/pavelvat
$(PKG)_DEPS     := gcc boost chromaprint cryptopp dlfcn-win32 fftw glew gst-libav gst-plugins-bad \
                   gst-plugins-good gst-plugins-ugly libarchive libechonest libid3tag liblastfm_qt4 \
                   libmpcdec libplist libusb1 protobuf qtsparkle_qt4 sparsehash

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, clementine-player/clementine)
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DCMAKE_INSTALL_PREFIX=$(PREFIX)/$(TARGET)/apps/$(PKG)
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    $(if $(BUILD_SHARED),
        $(INSTALL) -d '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstapetag.dll'            '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstapp.dll'               '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstasf.dll'               '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstaudioconvert.dll'      '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstaudiofx.dll'           '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstaudioparsers.dll'      '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstaudioresample.dll'     '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstaudiotestsrc.dll'      '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstautodetect.dll'        '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstcdio.dll'              '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstcoreelements.dll'      '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstdirectsoundsink.dll'   '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstequalizer.dll'         '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstfaad.dll'              '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstflac.dll'              '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstgdp.dll'               '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstgio.dll'               '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgsticydemux.dll'          '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstid3demux.dll'          '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstisomp4.dll'            '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstlame.dll'              '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstlibav.dll'             '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstmad.dll'               '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstmms.dll'               '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstogg.dll'               '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstopus.dll'              '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstplayback.dll'          '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstreplaygain.dll'        '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstsouphttpsrc.dll'       '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstspectrum.dll'          '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstspeex.dll'             '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgsttaglib.dll'            '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgsttcp.dll'               '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgsttypefindfunctions.dll' '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstudp.dll'               '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstvolume.dll'            '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstvorbis.dll'            '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstwavpack.dll'           '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/libgstwavparse.dll'          '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'

        $(INSTALL) -d '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/imageformats'
        $(INSTALL) '$(PREFIX)/$(TARGET)/qt/plugins/imageformats/qgif4.dll'  '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/imageformats'
        $(INSTALL) '$(PREFIX)/$(TARGET)/qt/plugins/imageformats/qjpeg4.dll' '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/imageformats'

        '$(TOP_DIR)/tools/copydlldeps.sh' -c \
                                          -d '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin' \
                                          -F '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin' \
                                          -F '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins' \
                                          -F '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/imageformats' \
                                          -X '$(PREFIX)/$(TARGET)/apps' \
                                          -R '$(PREFIX)/$(TARGET)';
    )
endef

# libechonest doesn't support static builds
$(PKG)_BUILD_STATIC =
