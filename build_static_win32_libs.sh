#!/bin/sh

set -e


#
#   configuration
#

#TARGET=`gcc -dumpmachine`  # native compiler (win32/MinGW, Cygwin)
#TARGET="i386-mingw32msvc"  # MinGW cross compiler (http://www.libsdl.org/extras/win32/cross/README.txt)
TARGET="i586-mingw32msvc"  # MinGW cross compiler of Debian (package mingw32)

BUILD=`gcc -dumpmachine`
ROOT=`pwd`
PREFIX="$ROOT/usr"
SOURCE="$ROOT/src"
DOWNLOAD="$ROOT/download"

VERSION_pkg_config=0.21
VERSION_zlib=1.2.3
VERSION_libxml2=2.6.29
VERSION_libpng=1.2.18
VERSION_jpeg=6b
VERSION_freetype=2.3.4
VERSION_fontconfig=2.4.2
VERSION_SDL=1.2.11
VERSION_smpeg=0.4.5+cvs20030824
VERSION_SDL_mixer=1.2.7


#
#   cleanup
#

rm -rfv "$PREFIX"
rm -rfv "$SOURCE"
mkdir -p "$PREFIX"
mkdir -p "$SOURCE"
mkdir -p "$DOWNLOAD"


#
#   download
#

cd "$DOWNLOAD"

tar tfz "pkg-config-$VERSION_pkg_config.tar.gz" >/dev/null ||
wget -c "http://pkgconfig.freedesktop.org/releases/pkg-config-$VERSION_pkg_config.tar.gz"

tar tfj "zlib-$VERSION_zlib.tar.bz2" >/dev/null ||
wget -c "http://downloads.sourceforge.net/libpng/zlib-$VERSION_zlib.tar.bz2"

tar tfz "libxml2-$VERSION_libxml2.tar.gz" >/dev/null ||
wget -c "ftp://xmlsoft.org/libxml2/libxml2-$VERSION_libxml2.tar.gz"

tar tfj "libpng-$VERSION_libpng.tar.bz2" >/dev/null ||
wget -c "http://downloads.sourceforge.net/libpng/libpng-$VERSION_libpng.tar.bz2"

tar tfz "jpegsrc.v$VERSION_jpeg.tar.gz" >/dev/null ||
wget -c "http://www.ijg.org/files/jpegsrc.v$VERSION_jpeg.tar.gz"

tar tfj "freetype-$VERSION_freetype.tar.bz2" >/dev/null ||
wget -c "http://download.savannah.gnu.org/releases/freetype/freetype-$VERSION_freetype.tar.bz2"

tar tfz "fontconfig-$VERSION_fontconfig.tar.gz" >/dev/null ||
wget -c "http://fontconfig.org/release/fontconfig-$VERSION_fontconfig.tar.gz"

tar tfz "SDL-$VERSION_SDL.tar.gz" >/dev/null ||
wget -c "http://www.libsdl.org/release/SDL-$VERSION_SDL.tar.gz"

tar tfz "smpeg_$VERSION_smpeg.orig.tar.gz" >/dev/null ||
wget -c "http://ftp.debian.org/debian/pool/main/s/smpeg/smpeg_$VERSION_smpeg.orig.tar.gz"
#svn checkout svn://svn.icculus.org/smpeg/trunk smpeg-trunk

tar tfz "SDL_mixer-$VERSION_SDL_mixer.tar.gz" >/dev/null ||
wget -c "http://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-$VERSION_SDL_mixer.tar.gz"


#
#   pkg-config
#
#   http://pkg-config.freedesktop.org/
#

cd "$SOURCE"
tar xfvz "$DOWNLOAD/pkg-config-$VERSION_pkg_config.tar.gz"
cd "pkg-config-$VERSION_pkg_config"
./configure --prefix="$PREFIX"
make install


#
#   zlib
#
#   http://www.zlib.net/
#

cd "$SOURCE"
tar xfvj "$DOWNLOAD/zlib-$VERSION_zlib.tar.bz2"
cd "zlib-$VERSION_zlib"
CC="$TARGET-gcc" RANLIB="$TARGET-ranlib" ./configure \
    --prefix="$PREFIX"
make install


#
#   libxml2
#
#   http://www.xmlsoft.org/
#

cd "$SOURCE"
tar xfvz "$DOWNLOAD/libxml2-$VERSION_libxml2.tar.gz"
cd "libxml2-$VERSION_libxml2"
./configure \
    --build="$BUILD" --host="$TARGET" \
    --disable-shared \
    --without-debug \
    --prefix="$PREFIX" \
    --without-python
make install bin_PROGRAMS= noinst_PROGRAMS=


#
#   libpng
#
#   http://www.libpng.org/
#

cd "$SOURCE"
tar xfvj "$DOWNLOAD/libpng-$VERSION_libpng.tar.bz2"
cd "libpng-$VERSION_libpng"
./configure \
    --build="$BUILD" --host="$TARGET" \
    --disable-shared \
    --prefix="$PREFIX"
make install bin_PROGRAMS= noinst_PROGRAMS=


#
#   jpeg
#
#   http://www.ijg.org/
#

cd "$SOURCE"
tar xfvz "$DOWNLOAD/jpegsrc.v$VERSION_jpeg.tar.gz"
cd "jpeg-$VERSION_jpeg"
./configure \
    CC="$TARGET-gcc" RANLIB="$TARGET-ranlib" \
    --disable-shared \
    --prefix="$PREFIX"
make install-lib


#
#   freetype
#
#   http://freetype.sourceforge.net/
#

cd "$SOURCE"
tar xfvj "$DOWNLOAD/freetype-$VERSION_freetype.tar.bz2"
cd "freetype-$VERSION_freetype"
./configure \
    --build="$BUILD" --host="$TARGET" \
    --disable-shared \
    --prefix="$PREFIX"
make install


#
#   fontconfig
#
#   http://fontconfig.org/
#

cd "$SOURCE"
tar xfvz "$DOWNLOAD/fontconfig-$VERSION_fontconfig.tar.gz"
cd "fontconfig-$VERSION_fontconfig"
./configure \
    --with-arch="$BUILD" --build="$BUILD" --host="$TARGET" \
    --disable-shared \
    --prefix="$PREFIX" \
    --with-freetype-config="$PREFIX/bin/freetype-config" \
    --enable-libxml2 \
    LIBXML2_CFLAGS="`$PREFIX/bin/xml2-config --cflags`" \
    LIBXML2_LIBS="`$PREFIX/bin/xml2-config --libs`"
sed 's,^install-data-local:.*,install-data-local:,' -i src/Makefile
make install bin_PROGRAMS= noinst_PROGRAMS=


#
#   SDL
#
#   http://www.libsdl.org/
#

cd "$SOURCE"
tar xfvz "$DOWNLOAD/SDL-$VERSION_SDL.tar.gz"
cd "SDL-$VERSION_SDL"
./configure \
    --build="$BUILD" --host="$TARGET" \
    --disable-shared \
    --disable-debug \
    --prefix="$PREFIX"
make install bin_PROGRAMS= noinst_PROGRAMS=


#
#   smpeg
#
#   http://icculus.org/smpeg/
#   http://packages.debian.org/unstable/source/smpeg
#

cd "$SOURCE"
tar xfvz "$DOWNLOAD/smpeg_$VERSION_smpeg.orig.tar.gz"
cd "smpeg-$VERSION_smpeg.orig"
#cp -R "$DOWNLOAD/smpeg-trunk" smpeg-trunk
#cd smpeg-trunk
./configure \
    --build="$BUILD" --host="$TARGET" \
    --disable-shared \
    --disable-debug \
    --prefix="$PREFIX" \
    PATH="$PREFIX/bin:$PATH" \
    --disable-gtk-player \
    --disable-opengl-player
make install bin_PROGRAMS= noinst_PROGRAMS=


#
#   SDL_mixer
#
#   http://www.libsdl.org/projects/SDL_mixer/
#

cd "$SOURCE"
tar xfvz "$DOWNLOAD/SDL_mixer-$VERSION_SDL_mixer.tar.gz"
cd "SDL_mixer-$VERSION_SDL_mixer"
./configure \
    --build="$BUILD" --host="$TARGET" \
    --disable-shared \
    --prefix="$PREFIX" \
    PATH="$PREFIX/bin:$PATH"
make install bin_PROGRAMS= noinst_PROGRAMS=


#
#   packing
#

cd "$PREFIX"
tar cv bin include lib | bzip2 -9 >"$ROOT/static_win32_libs.tar.bz2"

