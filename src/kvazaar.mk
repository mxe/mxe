# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

PKG             := kvazaar
$(PKG)_WEBSITE  := https://ultravideo.fi/kvazaar.html
$(PKG)_DESCR    := An open-source HEVC encoder
$(PKG)_VERSION  := 2.3.2
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := ddd0038696631ca5368d8e40efee36d2bbb805854b9b1dda8b12ea9b397ea951
$(PKG)_GH_CONF  := ultravideo/kvazaar/tags,v
$(PKG)_DEPS     := cc pthreads

define $(PKG)_BUILD
	# configure package with cmake
	cd "$(BUILD_DIR)" && "$(TARGET)-cmake" "$(SOURCE_DIR)" \
		-DCMAKE_INSTALL_PREFIX="$(PREFIX)/$(TARGET)" \
		-DCMAKE_PREFIX_PATH="$(PREFIX)/$(TARGET)" \
		-DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DBUILD_KVAZAAR_BINARY=ON \
		-DBUILD_SHARED_LIBS=ON \
		-DBUILD_TESTS=ON \
		-DUSE_CRYPTO=OFF \
		-DCMAKE_BUILD_TYPE=Release

	# build package and install
	$(MAKE) -C "$(BUILD_DIR)" -j $(JOBS)
	$(MAKE) -C "$(BUILD_DIR)" -j 1 install

	# --- Testing kvazaar.exe ---
	# kvazaar already compiles a test executable at:
	#   usr\$(TARGET)\bin\kvazaar.exe
	#
	# To quickly test it, create a small YUV video file:
	#   ffmpeg -f lavfi -i testsrc=size=640x360:rate=30 -pix_fmt yuv420p -t 5 -f rawvideo sample.yuv
	#
	# Then encode the "sample.yuv" output with kvazaar:
	#   .\kvazaar.exe -i sample.yuv --input-res 640x360 -o output.265
	#
	# Note:
	# - Adjust the input resolution (--input-res) to match your YUV file.
	# - You can convert the raw .265 output to MP4 to watch it:
	#     ffmpeg -i output.265 -c copy output.mp4
endef
