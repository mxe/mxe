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
$(PKG)_VERSION  := 925e74f
$(PKG)_CHECKSUM := 9da96ca2dc8adbba9dc9b6921def258a18d8c004eebacb897369b7821ec0c320
$(PKG)_GH_CONF  := clementine-player/Clementine/branches/master
$(PKG)_WEBSITE  := https://www.clementine-player.org/
$(PKG)_OWNER    := https://github.com/pavelvat
$(PKG)_DEPS     := cc boost chromaprint cryptopp fftw glew gst-libav gst-plugins-bad \
                   gst-plugins-good gst-plugins-ugly libechonest liblastfm_qt4 \
                   libmpcdec protobuf qtsparkle_qt4 sparsehash

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DCMAKE_INSTALL_PREFIX=$(PREFIX)/$(TARGET)/apps/$(PKG)
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    $(if $(BUILD_SHARED),
        $(INSTALL) -d '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstapetag.dll'            '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstapp.dll'               '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstasf.dll'               '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstaudioconvert.dll'      '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstaudiofx.dll'           '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstaudioparsers.dll'      '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstaudioresample.dll'     '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstaudiotestsrc.dll'      '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstautodetect.dll'        '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstcdio.dll'              '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstcoreelements.dll'      '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstdirectsound.dll'       '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstequalizer.dll'         '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstfaad.dll'              '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstflac.dll'              '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstgdp.dll'               '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstgio.dll'               '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgsticydemux.dll'          '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstid3demux.dll'          '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstisomp4.dll'            '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstlame.dll'              '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstlibav.dll'             '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstmms.dll'               '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstogg.dll'               '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstopus.dll'              '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstplayback.dll'          '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstreplaygain.dll'        '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstsoup.dll'              '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstspectrum.dll'          '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstspeex.dll'             '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgsttaglib.dll'            '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgsttcp.dll'               '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgsttypefindfunctions.dll' '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstudp.dll'               '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstvolume.dll'            '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstvorbis.dll'            '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstwavpack.dll'           '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'
        $(INSTALL) '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/libgstwavparse.dll'          '$(PREFIX)/$(TARGET)/apps/$(PKG)/bin/gstreamer-plugins'

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
