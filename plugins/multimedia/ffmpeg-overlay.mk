# This file is part of MXE. See LICENSE.md for licensing information.

$(info == Custom FFmpeg overrides: $(lastword $(MAKEFILE_LIST)))

gtk2_BUILD_SHARED = $(gtk2_BUILD)

ffmpeg_DEPS := sdl2 x265 $(filter-out sdl \
	gnutls \
	libass \
	libbluray \
	libbs2b \
	libcaca \
	speex \
	opencore-amr \
	vo-amrwbenc \
	xvidcore \
	, $(ffmpeg_DEPS))

ffmpeg_BUILD_SHARED = $(subst --enable-libx264, --enable-libx264 --enable-libx265, \
	$(filter-out \
	--enable-gnutls \
	--enable-libass \
	--enable-libbluray \
	--enable-libbs2b \
	--enable-libcaca \
	--enable-libspeex \
	--enable-libopencore-amrnb \
	--enable-libopencore-amrwb \
	--enable-libvo-amrwbenc \
	--enable-libxvid \
	, $(ffmpeg_BUILD)))

