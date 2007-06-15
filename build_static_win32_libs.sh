#!/bin/bash

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

PATH="$PREFIX/bin:$PATH"

VERSION_pkg_config=0.21
VERSION_pthreads=2-8-0
VERSION_zlib=1.2.3
VERSION_libxml2=2.6.29
VERSION_libgpg_error=1.5
VERSION_libgcrypt=1.2.4
VERSION_gnutls=1.6.3
VERSION_curl=7.16.2
VERSION_libpng=1.2.18
VERSION_jpeg=6b
VERSION_tiff=3.8.2
VERSION_freetype=2.3.4
VERSION_fontconfig=2.4.2
VERSION_gd=2.0.35RC4
VERSION_SDL=1.2.11
VERSION_smpeg=0.4.5+cvs20030824
VERSION_SDL_mixer=1.2.7
VERSION_geos=3.0.0rc4
VERSION_proj=4.5.0
VERSION_libgeotiff=1.2.3
VERSION_gdal=1.4.1


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

tar tfz "pkg-config-$VERSION_pkg_config.tar.gz" &>/dev/null ||
wget -c "http://pkgconfig.freedesktop.org/releases/pkg-config-$VERSION_pkg_config.tar.gz"

tar tfz "pthreads-w32-$VERSION_pthreads-release.tar.gz" &>/dev/null ||
wget -c "ftp://sourceware.org/pub/pthreads-win32/pthreads-w32-$VERSION_pthreads-release.tar.gz"

tar tfj "zlib-$VERSION_zlib.tar.bz2" &>/dev/null ||
wget -c "http://downloads.sourceforge.net/libpng/zlib-$VERSION_zlib.tar.bz2"

tar tfz "libxml2-$VERSION_libxml2.tar.gz" &>/dev/null ||
wget -c "ftp://xmlsoft.org/libxml2/libxml2-$VERSION_libxml2.tar.gz"

tar tfj "libgpg-error-$VERSION_libgpg_error.tar.bz2" &>/dev/null ||
wget -c "ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-$VERSION_libgpg_error.tar.bz2"

tar tfj "libgcrypt-$VERSION_libgcrypt.tar.bz2" &>/dev/null ||
wget -c "ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-$VERSION_libgcrypt.tar.bz2"

tar tfj "gnutls-$VERSION_gnutls.tar.bz2" &>/dev/null ||
wget -c "ftp://ftp.gnutls.org/pub/gnutls/gnutls-$VERSION_gnutls.tar.bz2"

tar tfj "curl-$VERSION_curl.tar.bz2" &>/dev/null ||
wget -c "http://curl.haxx.se/download/curl-$VERSION_curl.tar.bz2"

tar tfj "libpng-$VERSION_libpng.tar.bz2" &>/dev/null ||
wget -c "http://downloads.sourceforge.net/libpng/libpng-$VERSION_libpng.tar.bz2"

tar tfz "jpegsrc.v$VERSION_jpeg.tar.gz" &>/dev/null ||
wget -c "http://www.ijg.org/files/jpegsrc.v$VERSION_jpeg.tar.gz"

tar tfz "tiff-$VERSION_tiff.tar.gz" &>/dev/null ||
wget -c "ftp://ftp.remotesensing.org/pub/libtiff/tiff-$VERSION_tiff.tar.gz"

tar tfj "freetype-$VERSION_freetype.tar.bz2" &>/dev/null ||
wget -c "http://download.savannah.gnu.org/releases/freetype/freetype-$VERSION_freetype.tar.bz2"

tar tfz "fontconfig-$VERSION_fontconfig.tar.gz" &>/dev/null ||
wget -c "http://fontconfig.org/release/fontconfig-$VERSION_fontconfig.tar.gz"

tar tfj "gd-$VERSION_gd.tar.bz2" &>/dev/null ||
wget -c "http://www.libgd.org/releases/gd-$VERSION_gd.tar.bz2"

tar tfz "SDL-$VERSION_SDL.tar.gz" &>/dev/null ||
wget -c "http://www.libsdl.org/release/SDL-$VERSION_SDL.tar.gz"

tar tfz "smpeg_$VERSION_smpeg.orig.tar.gz" &>/dev/null ||
wget -c "http://ftp.debian.org/debian/pool/main/s/smpeg/smpeg_$VERSION_smpeg.orig.tar.gz"
#svn checkout -r ... svn://svn.icculus.org/smpeg/trunk ...

tar tfz "SDL_mixer-$VERSION_SDL_mixer.tar.gz" &>/dev/null ||
wget -c "http://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-$VERSION_SDL_mixer.tar.gz"

tar tfj "geos-$VERSION_geos.tar.bz2" &>/dev/null ||
wget -c "http://geos.refractions.net/geos-$VERSION_geos.tar.bz2"

tar tfz "proj-$VERSION_proj.tar.gz" &>/dev/null ||
wget -c "ftp://ftp.remotesensing.org/proj/proj-$VERSION_proj.tar.gz"

tar tfz "libgeotiff-$VERSION_libgeotiff.tar.gz" &>/dev/null ||
wget -c "ftp://ftp.remotesensing.org/pub/geotiff/libgeotiff/libgeotiff-$VERSION_libgeotiff.tar.gz"

tar tfz "gdal-$VERSION_gdal.tar.gz" &>/dev/null ||
wget -c "http://www.gdal.org/dl/gdal-$VERSION_gdal.tar.gz"


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
#   pthreads-w32
#
#   http://sourceware.org/pthreads-win32/
#

cd "$SOURCE"
tar xfvz "$DOWNLOAD/pthreads-w32-$VERSION_pthreads-release.tar.gz"
cd "pthreads-w32-$VERSION_pthreads-release"
sed '35i\#define PTW32_STATIC_LIB' -i pthread.h
make CROSS="$TARGET-" GC-static
install -d "$PREFIX/lib"
install -m664 libpthreadGC2.a "$PREFIX/lib/libpthread.a"
install -d "$PREFIX/include"
install -m664 pthread.h sched.h semaphore.h "$PREFIX/include/"


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
sed 's,`uname`,MinGW,g' -i xml2-config.in
./configure \
    --build="$BUILD" --host="$TARGET" \
    --disable-shared \
    --without-debug \
    --prefix="$PREFIX" \
    --without-python
make install bin_PROGRAMS= noinst_PROGRAMS=


#
#   libgpg-error
#
#   ftp://ftp.gnupg.org/gcrypt/libgpg-error/
#

cd "$SOURCE"
tar xfvj "$DOWNLOAD/libgpg-error-$VERSION_libgpg_error.tar.bz2"
cd "libgpg-error-$VERSION_libgpg_error"
./configure \
    --build="$BUILD" --host="$TARGET" \
    --disable-shared \
    --prefix="$PREFIX"
make install bin_PROGRAMS= noinst_PROGRAMS=


#
#   libgcrypt
#
#   ftp://ftp.gnupg.org/gcrypt/libgcrypt/
#

cd "$SOURCE"
tar xfvj "$DOWNLOAD/libgcrypt-$VERSION_libgcrypt.tar.bz2"
cd "libgcrypt-$VERSION_libgcrypt"
sed '26i\#include <ws2tcpip.h>' -i src/gcrypt.h.in
sed '26i\#include <ws2tcpip.h>' -i src/ath.h
sed 's,sys/times.h,sys/time.h,' -i cipher/random.c
./configure \
    --build="$BUILD" --host="$TARGET" \
    --disable-shared \
    --prefix="$PREFIX"
make install bin_PROGRAMS= noinst_PROGRAMS=


#
#   GnuTLS
#
#   http://www.gnu.org/software/gnutls/
#

cd "$SOURCE"
tar xfvj "$DOWNLOAD/gnutls-$VERSION_gnutls.tar.bz2"
cd "gnutls-$VERSION_gnutls"
./configure \
    --build="$BUILD" --host="$TARGET" \
    --disable-shared \
    --prefix="$PREFIX" \
    --disable-nls \
    --with-included-opencdk \
    --with-included-libtasn1 \
    --with-included-libcfg \
    --with-included-lzo
make install bin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=


#
#   cURL
#
#   http://curl.haxx.se/libcurl/
#

cd "$SOURCE"
tar xfvj "$DOWNLOAD/curl-$VERSION_curl.tar.bz2"
cd "curl-$VERSION_curl"
sed 's,GNUTLS_ENABLED = 1,GNUTLS_ENABLED=1,' -i configure
./configure \
    --build="$BUILD" --host="$TARGET" \
    --disable-shared \
    --prefix="$PREFIX" \
    --with-gnutls \
    CFLAGS="-I$PREFIX/include" \
    LDFLAGS="-L$PREFIX/lib"
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
    --prefix="$PREFIX" \
    CFLAGS="-I$PREFIX/include" \
    LDFLAGS="-L$PREFIX/lib"
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
#   LibTIFF
#
#   http://www.remotesensing.org/libtiff/
#

cd "$SOURCE"
tar xfvz "$DOWNLOAD/tiff-$VERSION_tiff.tar.gz"
cd "tiff-$VERSION_tiff"
./configure \
    --build="$BUILD" --host="$TARGET" \
    --disable-shared \
    --prefix="$PREFIX" \
    CFLAGS="-I$PREFIX/include" \
    LDFLAGS="-L$PREFIX/lib" \
    --without-x
make install bin_PROGRAMS= noinst_PROGRAMS=


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
sed 's,^install-data-local:.*,install-data-local:,' -i src/Makefile.in
./configure \
    --with-arch="$BUILD" --build="$BUILD" --host="$TARGET" \
    --disable-shared \
    --prefix="$PREFIX" \
    --enable-libxml2 \
    LIBXML2_CFLAGS="`xml2-config --cflags`" \
    LIBXML2_LIBS="`xml2-config --libs`"
make install bin_PROGRAMS= noinst_PROGRAMS=


#
#   GD
#   (without support for xpm)
#
#   http://www.libgd.org/
#

cd "$SOURCE"
tar xfvj "$DOWNLOAD/gd-$VERSION_gd.tar.bz2"
cd "gd-$VERSION_gd"
touch aclocal.m4
touch config.hin
touch Makefile.in
sed 's,-lX11 ,,g' -i configure
./configure \
    --build="$BUILD" --host="$TARGET" \
    --disable-shared \
    --prefix="$PREFIX" \
    --without-x \
    CFLAGS="-DNONDLL -DXMD_H" \
    LIBS="`xml2-config --libs`"
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
sed 's,for path in /usr/local; do,for path in; do,' -i configure
./configure \
    --build="$BUILD" --host="$TARGET" \
    --disable-shared \
    --prefix="$PREFIX"
make install bin_PROGRAMS= noinst_PROGRAMS=


#
#   GEOS
#
#   http://geos.refractions.net/
#

cd "$SOURCE"
tar xfvj "$DOWNLOAD/geos-$VERSION_geos.tar.bz2"
cd "geos-$VERSION_geos"
./configure \
    --build="$BUILD" --host="$TARGET" \
    --disable-shared \
    --prefix="$PREFIX" \
    --disable-swig
make install bin_PROGRAMS= noinst_PROGRAMS=


#
#   proj
#
#   http://www.remotesensing.org/proj/
#

cd "$SOURCE"
tar xfvz "$DOWNLOAD/proj-$VERSION_proj.tar.gz"
cd "proj-$VERSION_proj"
sed 's,install-exec-local[^:],,' -i src/Makefile.in
./configure \
    --build="$BUILD" --host="$TARGET" \
    --disable-shared \
    --prefix="$PREFIX"
make install bin_PROGRAMS= noinst_PROGRAMS=


#
#   GeoTiff
#
#   http://www.remotesensing.org/geotiff/
#

cd "$SOURCE"
tar xfvz "$DOWNLOAD/libgeotiff-$VERSION_libgeotiff.tar.gz"
cd "libgeotiff-$VERSION_libgeotiff"
sed 's,/usr/local,@prefix@,' -i bin/Makefile.in
touch configure
./configure \
    --build="$BUILD" --host="$TARGET" \
    --disable-shared \
    --prefix="$PREFIX" \
    CFLAGS="-I$PREFIX/include" \
    LDFLAGS="-L$PREFIX/lib"
make all install EXEEXT=.remove-me
rm -fv "$PREFIX"/bin/*.remove-me


#
#   GDAL
#
#   http://www.gdal.org/
#

cd "$SOURCE"
tar xfvz "$DOWNLOAD/gdal-$VERSION_gdal.tar.gz"
cd "gdal-$VERSION_gdal"
./configure \
    --build="$BUILD" --host="$TARGET" \
    --disable-shared \
    --prefix="$PREFIX" \
    EXTRA_INCLUDES="-I$PREFIX/include" \
    LDFLAGS="-L$PREFIX/lib" \
    LIBS="-ljpeg" \
    CC="$TARGET-g++" \
    CFLAGS="-O2 -fpermissive" \
    --with-png="$PREFIX" \
    --with-libtiff="$PREFIX" \
    --with-geotiff="$PREFIX" \
    --with-jpeg="$PREFIX" \
    --without-python \
    --without-ngpython
make lib-target install-lib
make -C port install
make -C gcore install
make -C frmts install
make -C alg install
make -C ogr install OGR_ENABLED=
make -C apps install BIN_LIST=


#
#   packing
#

cd "$PREFIX"
tar cv bin include lib | bzip2 -9 >"$ROOT/static_win32_libs.tar.bz2"

