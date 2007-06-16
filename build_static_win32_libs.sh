#!/bin/bash

set -e


#---
#   Configuration
#---

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


#---
#   Main
#---

case "$1" in
"")
    echo "Stage 1: $BASH '$0' --download"
    $BASH "$0" --download
    echo "Stage 2: $BASH '$0' --build"
    $BASH "$0" --build
    exit 0
    ;;
--download)
    # go ahead
    ;;
--build)
    # go ahead
    ;;
*)
    echo "Usage: $0 [ --download | --build ]"
    exit 1
    ;;
esac


#---
#   Prepare
#---

case "$1" in

--download)
    mkdir -p "$DOWNLOAD"
    ;;

--build)
    rm -rfv "$PREFIX"
    rm -rfv "$SOURCE"
    mkdir -p "$PREFIX"
    mkdir -p "$SOURCE"
    ;;

esac


#---
#   pkg-config
#
#   http://pkg-config.freedesktop.org/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfz "pkg-config-$VERSION_pkg_config.tar.gz" &>/dev/null ||
    wget -c "http://pkgconfig.freedesktop.org/releases/pkg-config-$VERSION_pkg_config.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/pkg-config-$VERSION_pkg_config.tar.gz"
    cd "pkg-config-$VERSION_pkg_config"
    ./configure --prefix="$PREFIX"
    make install
    ;;

esac


#---
#   pthreads-w32
#
#   http://sourceware.org/pthreads-win32/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfz "pthreads-w32-$VERSION_pthreads-release.tar.gz" &>/dev/null ||
    wget -c "ftp://sourceware.org/pub/pthreads-win32/pthreads-w32-$VERSION_pthreads-release.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/pthreads-w32-$VERSION_pthreads-release.tar.gz"
    cd "pthreads-w32-$VERSION_pthreads-release"
    sed '35i\#define PTW32_STATIC_LIB' -i pthread.h
    make CROSS="$TARGET-" GC-static
    install -d "$PREFIX/lib"
    install -m664 libpthreadGC2.a "$PREFIX/lib/libpthread.a"
    install -d "$PREFIX/include"
    install -m664 pthread.h sched.h semaphore.h "$PREFIX/include/"
    ;;

esac


#---
#   zlib
#
#   http://www.zlib.net/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfj "zlib-$VERSION_zlib.tar.bz2" &>/dev/null ||
    wget -c "http://downloads.sourceforge.net/libpng/zlib-$VERSION_zlib.tar.bz2"
    ;;

--build)
    cd "$SOURCE"
    tar xfvj "$DOWNLOAD/zlib-$VERSION_zlib.tar.bz2"
    cd "zlib-$VERSION_zlib"
    CC="$TARGET-gcc" RANLIB="$TARGET-ranlib" ./configure \
        --prefix="$PREFIX"
    make install
    ;;

esac


#---
#   libxml2
#
#   http://www.xmlsoft.org/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfz "libxml2-$VERSION_libxml2.tar.gz" &>/dev/null ||
    wget -c "ftp://xmlsoft.org/libxml2/libxml2-$VERSION_libxml2.tar.gz"
    ;;

--build)
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
    ;;

esac


#---
#   libgpg-error
#
#   ftp://ftp.gnupg.org/gcrypt/libgpg-error/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfj "libgpg-error-$VERSION_libgpg_error.tar.bz2" &>/dev/null ||
    wget -c "ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-$VERSION_libgpg_error.tar.bz2"
    ;;

--build)
    cd "$SOURCE"
    tar xfvj "$DOWNLOAD/libgpg-error-$VERSION_libgpg_error.tar.bz2"
    cd "libgpg-error-$VERSION_libgpg_error"
    ./configure \
        --build="$BUILD" --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX"
    make install bin_PROGRAMS= noinst_PROGRAMS=
    ;;

esac


#---
#   libgcrypt
#
#   ftp://ftp.gnupg.org/gcrypt/libgcrypt/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfj "libgcrypt-$VERSION_libgcrypt.tar.bz2" &>/dev/null ||
    wget -c "ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-$VERSION_libgcrypt.tar.bz2"
    ;;

--build)
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
    ;;

esac


#---
#   GnuTLS
#
#   http://www.gnu.org/software/gnutls/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfj "gnutls-$VERSION_gnutls.tar.bz2" &>/dev/null ||
    wget -c "ftp://ftp.gnutls.org/pub/gnutls/gnutls-$VERSION_gnutls.tar.bz2"
    ;;

--build)
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
    ;;

esac


#---
#   cURL
#
#   http://curl.haxx.se/libcurl/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfj "curl-$VERSION_curl.tar.bz2" &>/dev/null ||
    wget -c "http://curl.haxx.se/download/curl-$VERSION_curl.tar.bz2"
    ;;

--build)
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
    ;;

esac


#---
#   libpng
#
#   http://www.libpng.org/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfj "libpng-$VERSION_libpng.tar.bz2" &>/dev/null ||
    wget -c "http://downloads.sourceforge.net/libpng/libpng-$VERSION_libpng.tar.bz2"
    ;;

--build)
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
    ;;

esac


#---
#   jpeg
#
#   http://www.ijg.org/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfz "jpegsrc.v$VERSION_jpeg.tar.gz" &>/dev/null ||
    wget -c "http://www.ijg.org/files/jpegsrc.v$VERSION_jpeg.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/jpegsrc.v$VERSION_jpeg.tar.gz"
    cd "jpeg-$VERSION_jpeg"
    ./configure \
        CC="$TARGET-gcc" RANLIB="$TARGET-ranlib" \
        --disable-shared \
        --prefix="$PREFIX"
    make install-lib
    ;;

esac


#---
#   LibTIFF
#
#   http://www.remotesensing.org/libtiff/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfz "tiff-$VERSION_tiff.tar.gz" &>/dev/null ||
    wget -c "ftp://ftp.remotesensing.org/pub/libtiff/tiff-$VERSION_tiff.tar.gz"
    ;;

--build)
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
    ;;

esac


#---
#   freetype
#
#   http://freetype.sourceforge.net/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfj "freetype-$VERSION_freetype.tar.bz2" &>/dev/null ||
    wget -c "http://download.savannah.gnu.org/releases/freetype/freetype-$VERSION_freetype.tar.bz2"
    ;;

--build)
    cd "$SOURCE"
    tar xfvj "$DOWNLOAD/freetype-$VERSION_freetype.tar.bz2"
    cd "freetype-$VERSION_freetype"
    ./configure \
        --build="$BUILD" --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX"
    make install
    ;;

esac


#---
#   fontconfig
#
#   http://fontconfig.org/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfz "fontconfig-$VERSION_fontconfig.tar.gz" &>/dev/null ||
    wget -c "http://fontconfig.org/release/fontconfig-$VERSION_fontconfig.tar.gz"
    ;;

--build)
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
    ;;

esac


#---
#   GD
#   (without support for xpm)
#
#   http://www.libgd.org/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfj "gd-$VERSION_gd.tar.bz2" &>/dev/null ||
    wget -c "http://www.libgd.org/releases/gd-$VERSION_gd.tar.bz2"
    ;;

--build)
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
    ;;

esac


#---
#   SDL
#
#   http://www.libsdl.org/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfz "SDL-$VERSION_SDL.tar.gz" &>/dev/null ||
    wget -c "http://www.libsdl.org/release/SDL-$VERSION_SDL.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/SDL-$VERSION_SDL.tar.gz"
    cd "SDL-$VERSION_SDL"
    ./configure \
        --build="$BUILD" --host="$TARGET" \
        --disable-shared \
        --disable-debug \
        --prefix="$PREFIX"
    make install bin_PROGRAMS= noinst_PROGRAMS=
    ;;

esac


#---
#   smpeg
#
#   http://icculus.org/smpeg/
#   http://packages.debian.org/unstable/source/smpeg
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfz "smpeg_$VERSION_smpeg.orig.tar.gz" &>/dev/null ||
    wget -c "http://ftp.debian.org/debian/pool/main/s/smpeg/smpeg_$VERSION_smpeg.orig.tar.gz"
    #svn checkout -r ... svn://svn.icculus.org/smpeg/trunk ...
    ;;

--build)
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
    ;;

esac


#---
#   SDL_mixer
#
#   http://www.libsdl.org/projects/SDL_mixer/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfz "SDL_mixer-$VERSION_SDL_mixer.tar.gz" &>/dev/null ||
    wget -c "http://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-$VERSION_SDL_mixer.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/SDL_mixer-$VERSION_SDL_mixer.tar.gz"
    cd "SDL_mixer-$VERSION_SDL_mixer"
    sed 's,for path in /usr/local; do,for path in; do,' -i configure
    ./configure \
        --build="$BUILD" --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX"
    make install bin_PROGRAMS= noinst_PROGRAMS=
    ;;

esac


#---
#   GEOS
#
#   http://geos.refractions.net/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfj "geos-$VERSION_geos.tar.bz2" &>/dev/null ||
    wget -c "http://geos.refractions.net/geos-$VERSION_geos.tar.bz2"
    ;;

--build)
    cd "$SOURCE"
    tar xfvj "$DOWNLOAD/geos-$VERSION_geos.tar.bz2"
    cd "geos-$VERSION_geos"
    ./configure \
        --build="$BUILD" --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX" \
        --disable-swig
    make install bin_PROGRAMS= noinst_PROGRAMS=
    ;;

esac


#---
#   proj
#
#   http://www.remotesensing.org/proj/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfz "proj-$VERSION_proj.tar.gz" &>/dev/null ||
    wget -c "ftp://ftp.remotesensing.org/proj/proj-$VERSION_proj.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/proj-$VERSION_proj.tar.gz"
    cd "proj-$VERSION_proj"
    sed 's,install-exec-local[^:],,' -i src/Makefile.in
    ./configure \
        --build="$BUILD" --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX"
    make install bin_PROGRAMS= noinst_PROGRAMS=
    ;;

esac


#---
#   GeoTiff
#
#   http://www.remotesensing.org/geotiff/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfz "libgeotiff-$VERSION_libgeotiff.tar.gz" &>/dev/null ||
    wget -c "ftp://ftp.remotesensing.org/pub/geotiff/libgeotiff/libgeotiff-$VERSION_libgeotiff.tar.gz"
    ;;

--build)
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
    ;;

esac


#---
#   GDAL
#
#   http://www.gdal.org/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfz "gdal-$VERSION_gdal.tar.gz" &>/dev/null ||
    wget -c "http://www.gdal.org/dl/gdal-$VERSION_gdal.tar.gz"
    ;;

--build)
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
    make lib-target
    make install-lib
    make -C port  install
    make -C gcore install
    make -C frmts install
    make -C alg   install
    make -C ogr   install OGR_ENABLED=
    make -C apps  install BIN_LIST=
    ;;

esac


#---
#   Create package
#---

case "$1" in

--build)
    cd "$PREFIX"
    tar cv bin include lib | bzip2 -9 >"$ROOT/static_win32_libs.tar.bz2"
    ;;

esac
