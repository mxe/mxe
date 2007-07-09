#!/bin/bash
set -ex


#---
#   MinGW cross compiling environment  (pre-1.1)
#   =================================
#
#   http://www.profv.de/mingw_cross_env/
#
#   This script compiles a MinGW cross compiler and cross compiles
#   many free libraries such as GD and SDL. Thus, it provides you
#   a nice MinGW cross compiling environment. All necessary source
#   packages are downloaded automatically.
#
#   This script is designed to run on any Unix system. It also runs
#   partly on MSYS. It needs GNU make and GNU sed, so FreeBSD users
#   need the ports textproc/gsed and devel/gmake.
#
#
#   Usage:  ./build_mingw_cross_env.sh  [ action ]
#
#   <no action>
#       same as '--download', followed by '--build'.
#
#   --list
#       list all supported packages and their versions to
#       be built.
#
#   --new-versions
#       retrieve the new version numbers of all packages
#       (modifies the script in-place, use with caution!)
#
#   --download
#       download all packages in download/
#       (resumes incomplete downloads)
#
#   --build
#       build the packages in src/ and usr/, create mingw_cross_env.tar.gz
#       (needs a prepared download/ directory
#        or a previous '--download' run)
#
#   --build-experimental
#       build the experimental packages
#       (allows fast testing of new additions to the script,
#        needs a prepared mingw_cross_env.tar.gz archive
#        or a previous '--build' run)
#---


#---
#   Copyright (c)  Volker Grabsch <vog@notjusthosting.com>
#                  Rocco Rutte <pdmef@gmx.net>
#
#   Permission is hereby granted, free of charge, to any person obtaining
#   a copy of this software and associated documentation files (the
#   "Software"), to deal in the Software without restriction, including
#   without limitation the rights to use, copy, modify, merge, publish,
#   distribute, sublicense, and/or sell copies of the Software, and to
#   permit persons to whom the Software is furnished to do so, subject
#   to the following conditions:
#
#   The above copyright notice and this permission notice shall be
#   included in all copies or substantial portions of the Software.
# 
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
#   CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
#   TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
#   SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#---


#---
#   Configuration
#---

TARGET="i386-mingw32msvc"
ROOT=`pwd`
PREFIX="$ROOT/usr"
SOURCE="$ROOT/src"
DOWNLOAD="$ROOT/download"
SOURCEFORGE_MIRROR=downloads.sourceforge.net

PATH="$PREFIX/bin:$PATH"

VERSION_mingw_runtime=3.12
VERSION_w32api=3.9
VERSION_binutils=2.17.50-20060824-1
VERSION_gcc=3.4.5-20060117-1
VERSION_pkg_config=0.21
VERSION_pthreads=2-8-0
VERSION_zlib=1.2.3
VERSION_pdcurses=32
VERSION_gettext=0.16.1
VERSION_libiconv=1.9.2
VERSION_winpcap=4_0_1
VERSION_libdnet=1.11
VERSION_libgpg_error=1.5
VERSION_libgcrypt=1.2.4
VERSION_gnutls=1.6.3
VERSION_libxml2=2.6.29
VERSION_libxslt=1.1.21
VERSION_xmlwrapp=0.5.0
VERSION_curl=7.16.3
VERSION_libpng=1.2.18
VERSION_jpeg=6b
VERSION_tiff=3.8.2
VERSION_giflib=4.1.4
VERSION_freetype=2.3.5
VERSION_fontconfig=2.4.2
VERSION_libmikmod=3.2.0-beta2
VERSION_ogg=1.1.3
VERSION_vorbis=1.1.2
VERSION_gd=2.0.35
VERSION_SDL=1.2.11
VERSION_smpeg=0.4.5+cvs20030824
VERSION_SDL_mixer=1.2.7
VERSION_SDL_image=1.2.5
VERSION_fltk=1.1.7
VERSION_geos=3.0.0rc4
VERSION_proj=4.5.0
VERSION_libgeotiff=1.2.3
VERSION_gdal=1.4.2
VERSION_pdflib_lite=7.0.1
VERSION_libowfat=0.25


#---
#   Portability
#---

MAKE=gmake
$MAKE --version >&2 || MAKE=make

SED=gsed
$SED  --version >&2 || SED=sed


#---
#   Main
#---

case "$1" in
"")
    $BASH "$0" --download
    $BASH "$0" --build
    exit 0
    ;;
--list)
    # transform all VERSION_xxx declaration lines of this script
    set - -x
    awk <"$0" '
        BEGIN      { FS="^VERSION_|=" }
        /^VERSION/ { printf "%-13s  %s\n", $2, $3 }' |
    sort
    exit 0
    ;;
--new-versions|--download|--build|--build-experimental)
    # go ahead
    ;;
*)
    # display the first comments of this script as help message
    set - -x
    $SED -n '/(c)/ Q; s/\(^$\|^#$\|^#   \)//p' "$0" |
    more
    exit 1
    ;;
esac


#---
#   Prepare
#---

case "$1" in

--new-versions)
    cp -p "$0" "$0.backup_`date +%Y-%m-%d_%H:%M:%S`"
    ;;

--download)
    mkdir -p "$DOWNLOAD"
    ;;

--build)
    rm -rfv  "$PREFIX" "$SOURCE"
    mkdir -p "$PREFIX" "$SOURCE"
    ;;

--build-experimental)
    tar tfz "$ROOT/mingw_cross_env.tar.gz" >/dev/null
    rm -rfv  "$PREFIX" "$SOURCE"
    mkdir -p "$PREFIX" "$SOURCE"
    cd "$PREFIX"
    tar xfvz "$ROOT/mingw_cross_env.tar.gz"
    ;;

esac


#---
#   MinGW Runtime
#
#   http://mingw.sourceforge.net/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=2435' |
        $SED -n 's,.*mingw-runtime-\([0-9][^>]*\)-src\.tar.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_mingw_runtime=.*,VERSION_mingw_runtime=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfz "mingw-runtime-$VERSION_mingw_runtime.tar.gz" &>/dev/null ||
    wget -c "http://$SOURCEFORGE_MIRROR/mingw/mingw-runtime-$VERSION_mingw_runtime.tar.gz"
    ;;

--build)
    install -d "$PREFIX/$TARGET"
    cd "$PREFIX/$TARGET"
    tar xfvz "$DOWNLOAD/mingw-runtime-$VERSION_mingw_runtime.tar.gz"
    ;;

esac


#---
#   MinGW Windows API
#
#   http://mingw.sourceforge.net/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=2435' |
        $SED -n 's,.*w32api-\([0-9][^>]*\)-src\.tar.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_w32api=.*,VERSION_w32api=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfz "w32api-$VERSION_w32api.tar.gz" &>/dev/null ||
    wget -c "http://$SOURCEFORGE_MIRROR/mingw/w32api-$VERSION_w32api.tar.gz"
    ;;

--build)
    install -d "$PREFIX/$TARGET"
    cd "$PREFIX/$TARGET"
    tar xfvz "$DOWNLOAD/w32api-$VERSION_w32api.tar.gz"
    # fix incompatibilities with gettext
    $SED 's,\(SUBLANG_BENGALI_INDIA\t\)0x01,\10x00,'    -i "$PREFIX/$TARGET/include/winnt.h"
    $SED 's,\(SUBLANG_PUNJABI_INDIA\t\)0x01,\10x00,'    -i "$PREFIX/$TARGET/include/winnt.h"
    $SED 's,\(SUBLANG_ROMANIAN_ROMANIA\t\)0x01,\10x00,' -i "$PREFIX/$TARGET/include/winnt.h"
    # fix incompatibilities with jpeg
    $SED 's,typedef unsigned char boolean;,,'           -i "$PREFIX/$TARGET/include/rpcndr.h"
    # fix missing definitions for WinPcap and libdnet
    $SED '1i\#include <wtypes.h>'                       -i "$PREFIX/$TARGET/include/iphlpapi.h"
    $SED '1i\#include <wtypes.h>'                       -i "$PREFIX/$TARGET/include/wincrypt.h"
    ;;

esac


#---
#   MinGW binutils
#
#   http://mingw.sourceforge.net/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=2435' |
        $SED -n 's,.*binutils-\([0-9][^>]*\)-src\.tar.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_binutils=.*,VERSION_binutils=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfz "binutils-$VERSION_binutils-src.tar.gz" &>/dev/null ||
    wget -c "http://$SOURCEFORGE_MIRROR/mingw/binutils-$VERSION_binutils-src.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/binutils-$VERSION_binutils-src.tar.gz"
    cd "binutils-$VERSION_binutils-src"
    ./configure \
        --target="$TARGET" \
        --prefix="$PREFIX" \
        --with-gcc \
        --with-gnu-ld \
        --with-gnu-as \
        --disable-nls \
        --disable-shared
    $MAKE all install
    cd "$SOURCE"
    rm -rfv "binutils-$VERSION_binutils-src"
    strip -sv \
        "$PREFIX/bin/$TARGET-addr2line" \
        "$PREFIX/bin/$TARGET-ar" \
        "$PREFIX/bin/$TARGET-as" \
        "$PREFIX/bin/$TARGET-c++filt" \
        "$PREFIX/bin/$TARGET-dlltool" \
        "$PREFIX/bin/$TARGET-dllwrap" \
        "$PREFIX/bin/$TARGET-gprof" \
        "$PREFIX/bin/$TARGET-ld" \
        "$PREFIX/bin/$TARGET-nm" \
        "$PREFIX/bin/$TARGET-objcopy" \
        "$PREFIX/bin/$TARGET-objdump" \
        "$PREFIX/bin/$TARGET-ranlib" \
        "$PREFIX/bin/$TARGET-readelf" \
        "$PREFIX/bin/$TARGET-size" \
        "$PREFIX/bin/$TARGET-strings" \
        "$PREFIX/bin/$TARGET-strip" \
        "$PREFIX/bin/$TARGET-windres" \
        "$PREFIX/$TARGET/bin/ar" \
        "$PREFIX/$TARGET/bin/as" \
        "$PREFIX/$TARGET/bin/dlltool" \
        "$PREFIX/$TARGET/bin/ld" \
        "$PREFIX/$TARGET/bin/nm" \
        "$PREFIX/$TARGET/bin/objdump" \
        "$PREFIX/$TARGET/bin/ranlib" \
        "$PREFIX/$TARGET/bin/strip" \
        "$PREFIX/lib/libiberty.a"
    ;;

esac


#---
#   MinGW GCC
#
#   http://mingw.sourceforge.net/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=2435' |
        $SED -n 's,.*gcc-core-\([0-9][^>]*\)-src\.tar.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_gcc=.*,VERSION_gcc=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfz "gcc-core-$VERSION_gcc-src.tar.gz" &>/dev/null ||
    wget -c "http://$SOURCEFORGE_MIRROR/mingw/gcc-core-$VERSION_gcc-src.tar.gz"
    tar tfz "gcc-g++-$VERSION_gcc-src.tar.gz" &>/dev/null ||
    wget -c "http://$SOURCEFORGE_MIRROR/mingw/gcc-g++-$VERSION_gcc-src.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/gcc-core-$VERSION_gcc-src.tar.gz"
    tar xfvz "$DOWNLOAD/gcc-g++-$VERSION_gcc-src.tar.gz"
    cd "gcc-$VERSION_gcc"
    ./configure \
        --target="$TARGET" \
        --prefix="$PREFIX" \
        --enable-languages="c,c++" \
        --enable-version-specific-runtime-libs \
        --with-gcc \
        --with-gnu-ld \
        --with-gnu-as \
        --disable-nls \
        --disable-shared \
        --without-x \
        --enable-threads=win32 \
        --disable-win32-registry \
        --enable-sjlj-exceptions
    $MAKE all install
    cd "$SOURCE"
    rm -rfv "gcc-$VERSION_gcc"
    VERSION_gcc_short=`echo "$VERSION_gcc" | cut -d'-' -f1`
    strip -sv \
        "$PREFIX/bin/$TARGET-c++" \
        "$PREFIX/bin/$TARGET-cpp" \
        "$PREFIX/bin/$TARGET-g++" \
        "$PREFIX/bin/$TARGET-gcc" \
        "$PREFIX/bin/$TARGET-gcc-3.4.5" \
        "$PREFIX/bin/$TARGET-gcov" \
        "$PREFIX/$TARGET/bin/c++" \
        "$PREFIX/$TARGET/bin/g++" \
        "$PREFIX/$TARGET/bin/gcc" \
        "$PREFIX/libexec/gcc/$TARGET/$VERSION_gcc_short/cc1" \
        "$PREFIX/libexec/gcc/$TARGET/$VERSION_gcc_short/cc1plus" \
        "$PREFIX/libexec/gcc/$TARGET/$VERSION_gcc_short/collect2"
    ;;

esac


#---
#   pkg-config
#
#   http://pkg-config.freedesktop.org/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://pkgconfig.freedesktop.org/' |
        $SED -n 's,.*current release of pkg-config is version \([0-9][^ ]*\) and.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_pkg_config=.*,VERSION_pkg_config=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfz "pkg-config-$VERSION_pkg_config.tar.gz" &>/dev/null ||
    wget -c "http://pkgconfig.freedesktop.org/releases/pkg-config-$VERSION_pkg_config.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/pkg-config-$VERSION_pkg_config.tar.gz"
    cd "pkg-config-$VERSION_pkg_config"
    ./configure --prefix="$PREFIX/$TARGET"
    $MAKE install
    cd "$SOURCE"
    rm -rfv "pkg-config-$VERSION_pkg_config"
    install -d "$PREFIX/bin"
    rm -fv "$PREFIX/bin/$TARGET-pkg-config"
    ln -s "../$TARGET/bin/pkg-config" "$PREFIX/bin/$TARGET-pkg-config"
    ;;

esac


#---
#   pthreads-w32
#
#   http://sourceware.org/pthreads-win32/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'ftp://sourceware.org/pub/pthreads-win32/Release_notes' |
        $SED -n 's,^RELEASE \([0-9][^[:space:]]*\).*,\1,p' | 
        tr '.' '-' |
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_pthreads=.*,VERSION_pthreads=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfz "pthreads-w32-$VERSION_pthreads-release.tar.gz" &>/dev/null ||
    wget -c "ftp://sourceware.org/pub/pthreads-win32/pthreads-w32-$VERSION_pthreads-release.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/pthreads-w32-$VERSION_pthreads-release.tar.gz"
    cd "pthreads-w32-$VERSION_pthreads-release"
    $SED '35i\#define PTW32_STATIC_LIB' -i pthread.h
    $MAKE GC-static CROSS="$TARGET-"
    install -d "$PREFIX/$TARGET/lib"
    install -m664 libpthreadGC2.a "$PREFIX/$TARGET/lib/libpthread.a"
    install -d "$PREFIX/$TARGET/include"
    install -m664 pthread.h sched.h semaphore.h "$PREFIX/$TARGET/include/"
    cd "$SOURCE"
    rm -rfv "pthreads-w32-$VERSION_pthreads-release"
    ;;

esac


#---
#   zlib
#
#   http://www.zlib.net/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=5624' |
        $SED -n 's,.*zlib-\([0-9][^>]*\)\.tar.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_zlib=.*,VERSION_zlib=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfj "zlib-$VERSION_zlib.tar.bz2" &>/dev/null ||
    wget -c "http://$SOURCEFORGE_MIRROR/libpng/zlib-$VERSION_zlib.tar.bz2"
    ;;

--build)
    cd "$SOURCE"
    tar xfvj "$DOWNLOAD/zlib-$VERSION_zlib.tar.bz2"
    cd "zlib-$VERSION_zlib"
    CC="$TARGET-gcc" RANLIB="$TARGET-ranlib" ./configure \
        --prefix="$PREFIX/$TARGET"
    $MAKE install
    cd "$SOURCE"
    rm -rfv "zlib-$VERSION_zlib"
    ;;

esac


#---
#   PDcurses
#
#   http://pdcurses.sourceforge.net/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=30480' |
        $SED -n 's,.*pdcurs\([0-9][^>]*\)\.zip.*,\1,p' |
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_pdcurses=.*,VERSION_pdcurses=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    unzip -t "pdcurs$VERSION_pdcurses.zip" &>/dev/null ||
    wget -c "http://$SOURCEFORGE_MIRROR/pdcurses/pdcurs$VERSION_pdcurses.zip"
    ;;

--build)
    cd "$SOURCE"
    unzip "$DOWNLOAD/pdcurs$VERSION_pdcurses.zip" -d "pdcurs$VERSION_pdcurses"
    cd "pdcurs$VERSION_pdcurses"
    $SED 's,copy,cp,' -i win32/mingwin32.mak
    $MAKE libs -f win32/mingwin32.mak \
        CC="$TARGET-gcc" \
        LIBEXE="$TARGET-ar" \
        DLL=N \
        PDCURSES_SRCDIR=. \
        WIDE=Y \
        UTF8=Y
    $TARGET-ranlib pdcurses.a panel.a
    install -d "$PREFIX/$TARGET/include/"
    install -m644 curses.h panel.h term.h "$PREFIX/$TARGET/include/"
    install -d "$PREFIX/$TARGET/lib/"
    install -m644 pdcurses.a "$PREFIX/$TARGET/lib/libpdcurses.a"
    install -m644 panel.a    "$PREFIX/$TARGET/lib/libpanel.a"
    cd "$SOURCE"
    rm -rfv "pdcurs$VERSION_pdcurses"
    ;;

esac


#---
#   gettext
#
#   http://www.gnu.org/software/gettext/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'ftp://ftp.gnu.org/pub/gnu/gettext/' |
        $SED -n 's,.*gettext-\([0-9][^>]*\)\.tar.*,\1,p' |
        sort | tail -1`
    test -n "$VERSION"
    $SED "s,^VERSION_gettext=.*,VERSION_gettext=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfz "gettext-$VERSION_gettext.tar.gz" &>/dev/null ||
    wget -c "ftp://ftp.gnu.org/pub/gnu/gettext/gettext-$VERSION_gettext.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/gettext-$VERSION_gettext.tar.gz"
    cd "gettext-$VERSION_gettext"
    cd gettext-runtime
    ./configure \
        --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET" \
        --enable-threads=win32
    $MAKE install -C intl
    cd "$SOURCE"
    rm -rfv "gettext-$VERSION_gettext"
    ;;

esac


#---
#   libiconv
#
#   http://www.gnu.org/software/libiconv/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://ftp.gnu.org/pub/gnu/libiconv/' |
        $SED -n 's,.*libiconv-\([0-9]*\)\.\([0-9]*\)\(\.[0-9]*\)\.tar.*,\1.\2\3,p' |
        sort | tail -1`
    test -n "$VERSION"
    $SED "s,^VERSION_libiconv=.*,VERSION_libiconv=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfz "libiconv-$VERSION_libiconv.tar.gz" &>/dev/null ||
    wget -c "http://ftp.gnu.org/pub/gnu/libiconv/libiconv-$VERSION_libiconv.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/libiconv-$VERSION_libiconv.tar.gz"
    cd "libiconv-$VERSION_libiconv"
    ./configure \
        --host="$TARGET" \
        --prefix="$PREFIX/$TARGET" \
        --disable-shared \
        --disable-nls
    $MAKE install
    cd "$SOURCE"
    rm -rfv "libiconv-$VERSION_libiconv"
    ;;

esac


#---
#   WinPcap
#
#   http://www.winpcap.org/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://www.winpcap.org/devel.htm' |
        $SED -n 's,.*WpcapSrc_\([0-9][^>]*\)\.zip.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_winpcap=.*,VERSION_winpcap=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    unzip -t "WpcapSrc_$VERSION_winpcap.zip" &>/dev/null ||
    wget -c "http://www.winpcap.org/install/bin/WpcapSrc_$VERSION_winpcap.zip"
    ;;

--build)
    cd "$SOURCE"
    unzip "$DOWNLOAD/WpcapSrc_$VERSION_winpcap.zip" -d "WpcapSrc_$VERSION_winpcap"
    cd "WpcapSrc_$VERSION_winpcap"
    cd winpcap
    mv Common common
    cp -p common/Devioctl.h   common/devioctl.h
    cp -p common/Ntddndis.h   common/ntddndis.h
    cp -p common/Ntddpack.h   common/ntddpack.h
    cp -p common/Packet32.h   common/packet32.h
    cp -p common/WpcapNames.h common/wpcapnames.h
    $TARGET-gcc -Icommon -O -c Packet9x/DLL/Packet32.c
    $TARGET-ar rc libpacket.a Packet32.o
    $TARGET-ranlib libpacket.a
    install -d "$PREFIX/$TARGET/include"
    install -m644 common/*.h "$PREFIX/$TARGET/include/"
    install -d "$PREFIX/$TARGET/lib"
    install -m644 libpacket.a "$PREFIX/$TARGET/lib/"
    mv wpcap/libpcap/Win32/Include/ip6_misc.h wpcap/libpcap/Win32/Include/IP6_misc.h
    $SED 's,-DHAVE_AIRPCAP_API,,'    -i wpcap/PRJ/GNUmakefile
    echo -e 'libwpcap.a: ${OBJS}'   >> wpcap/PRJ/GNUmakefile
    echo -e '\t${AR} rc $@ ${OBJS}' >> wpcap/PRJ/GNUmakefile
    echo -e '\t${RANLIB} $@'        >> wpcap/PRJ/GNUmakefile
    echo "/* already handled by <ws2tcpip.h> */" > wpcap/libpcap/Win32/Src/gai_strerror.c
    cd wpcap/PRJ
    CC="$TARGET-gcc" \
    AR="$TARGET-ar" \
    RANLIB="$TARGET-ranlib" \
    $MAKE libwpcap.a
    install -d "$PREFIX/$TARGET/include"
    install -m644 ../libpcap/*.h ../Win32-Extensions/*.h "$PREFIX/$TARGET/include/"
    install -d "$PREFIX/$TARGET/lib"
    install -m644 libwpcap.a "$PREFIX/$TARGET/lib/"
    cd "$SOURCE"
    rm -rfv "WpcapSrc_$VERSION_winpcap"
    ;;

esac


#---
#   libdnet
#
#   http://libdnet.sourceforge.net/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=36243' |
        $SED -n 's,.*libdnet-\([0-9][^>]*\)\.tar.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_libdnet=.*,VERSION_libdnet=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfz "libdnet-$VERSION_libdnet.tar.gz" &>/dev/null ||
    wget -c "http://$SOURCEFORGE_MIRROR/libdnet/libdnet-$VERSION_libdnet.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/libdnet-$VERSION_libdnet.tar.gz"
    cd "libdnet-$VERSION_libdnet"
    $SED 's,CYGWIN=no,CYGWIN=yes,g'                 -i configure
    $SED 's,cat /proc/sys/kernel/ostype,,g'         -i configure
    $SED 's,test -d /usr/include/mingw,true,'       -i configure
    $SED 's,Iphlpapi,iphlpapi,g'                    -i configure
    $SED 's,packet.lib,libpacket.a,'                -i configure
    $SED 's,-lpacket,-lpacket -lws2_32,g'           -i configure
    $SED "s,/usr/include,$PREFIX/$TARGET/include,g" -i configure
    ./configure \
        --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET"
    $MAKE install bin_PROGRAMS= noinst_PROGRAMS=
    cd "$SOURCE"
    rm -rfv "libdnet-$VERSION_libdnet"
    ;;

esac


#---
#   libgpg-error
#
#   ftp://ftp.gnupg.org/gcrypt/libgpg-error/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'ftp://ftp.gnupg.org/gcrypt/libgpg-error/' |
        $SED -n 's,.*libgpg-error-\([0-9][^>]*\)\.tar.*,\1,p' | 
        tail -1`
    test -n "$VERSION"
    $SED "s,^VERSION_libgpg_error=.*,VERSION_libgpg_error=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfj "libgpg-error-$VERSION_libgpg_error.tar.bz2" &>/dev/null ||
    wget -c "ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-$VERSION_libgpg_error.tar.bz2"
    ;;

--build)
    cd "$SOURCE"
    tar xfvj "$DOWNLOAD/libgpg-error-$VERSION_libgpg_error.tar.bz2"
    cd "libgpg-error-$VERSION_libgpg_error"
    # wine confuses the cross-compiling detection, so set it explicitly
    $SED 's,cross_compiling=no,cross_compiling=yes,' -i configure
    ./configure \
        --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET"
    $MAKE install bin_PROGRAMS= noinst_PROGRAMS=
    cd "$SOURCE"
    rm -rfv "libgpg-error-$VERSION_libgpg_error"
    ;;

esac


#---
#   libgcrypt
#
#   ftp://ftp.gnupg.org/gcrypt/libgcrypt/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'ftp://ftp.gnupg.org/gcrypt/libgcrypt/' |
        $SED -n 's,.*libgcrypt-\([0-9][^>]*\)\.tar.*,\1,p' | 
        tail -1`
    test -n "$VERSION"
    $SED "s,^VERSION_libgcrypt=.*,VERSION_libgcrypt=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfj "libgcrypt-$VERSION_libgcrypt.tar.bz2" &>/dev/null ||
    wget -c "ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-$VERSION_libgcrypt.tar.bz2"
    ;;

--build)
    cd "$SOURCE"
    tar xfvj "$DOWNLOAD/libgcrypt-$VERSION_libgcrypt.tar.bz2"
    cd "libgcrypt-$VERSION_libgcrypt"
    $SED '26i\#include <ws2tcpip.h>' -i src/gcrypt.h.in
    $SED '26i\#include <ws2tcpip.h>' -i src/ath.h
    $SED 's,sys/times.h,sys/time.h,' -i cipher/random.c
    # wine confuses the cross-compiling detection, so set it explicitly
    $SED 's,cross_compiling=no,cross_compiling=yes,' -i configure
    ./configure \
        --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET" \
        --with-gpg-error-prefix="$PREFIX/$TARGET"
    $MAKE install bin_PROGRAMS= noinst_PROGRAMS=
    cd "$SOURCE"
    rm -rfv "libgcrypt-$VERSION_libgcrypt"
    ;;

esac


#---
#   GnuTLS
#
#   http://www.gnu.org/software/gnutls/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://www.gnu.org/software/gnutls/news.html' |
        $SED -n 's,.*GnuTLS \([0-9][^>]*\)</a>.*stable branch.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_gnutls=.*,VERSION_gnutls=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfj "gnutls-$VERSION_gnutls.tar.bz2" &>/dev/null ||
    wget -c "ftp://ftp.gnutls.org/pub/gnutls/gnutls-$VERSION_gnutls.tar.bz2"
    ;;

--build)
    cd "$SOURCE"
    tar xfvj "$DOWNLOAD/gnutls-$VERSION_gnutls.tar.bz2"
    cd "gnutls-$VERSION_gnutls"
    echo "/* DEACTIVATED */" >gl/gai_strerror.c
    ./configure \
        --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET" \
        --with-libgcrypt-prefix="$PREFIX/$TARGET" \
        --disable-nls \
        --with-included-opencdk \
        --with-included-libtasn1 \
        --with-included-libcfg \
        --with-included-lzo
    $MAKE install bin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
    cd "$SOURCE"
    rm -rfv "gnutls-$VERSION_gnutls"
    ;;

esac


#---
#   libxml2
#
#   http://www.xmlsoft.org/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'ftp://xmlsoft.org/libxml2/' |
        $SED -n 's,.*LATEST_LIBXML2_IS_\([0-9][^>]*\)</a>.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_libxml2=.*,VERSION_libxml2=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfz "libxml2-$VERSION_libxml2.tar.gz" &>/dev/null ||
    wget -c "ftp://xmlsoft.org/libxml2/libxml2-$VERSION_libxml2.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/libxml2-$VERSION_libxml2.tar.gz"
    cd "libxml2-$VERSION_libxml2"
    $SED 's,`uname`,MinGW,g' -i xml2-config.in
    ./configure \
        --host="$TARGET" \
        --disable-shared \
        --without-debug \
        --prefix="$PREFIX/$TARGET" \
        --without-python
    $MAKE install bin_PROGRAMS= noinst_PROGRAMS=
    cd "$SOURCE"
    rm -rfv "libxml2-$VERSION_libxml2"
    ;;

esac


#---
#   libxslt
#
#   http://xmlsoft.org/XSLT/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'ftp://xmlsoft.org/libxslt/' |
        $SED -n 's,.*LATEST_LIBXSLT_IS_\([0-9][^>]*\)</a>.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_libxslt=.*,VERSION_libxslt=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfz "libxslt-$VERSION_libxslt.tar.gz" &>/dev/null ||
    wget -c "ftp://xmlsoft.org/libxslt/libxslt-$VERSION_libxslt.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/libxslt-$VERSION_libxslt.tar.gz"
    cd "libxslt-$VERSION_libxslt"
    ./configure \
        --host="$TARGET" \
        --disable-shared \
        --without-debug \
        --prefix="$PREFIX/$TARGET" \
        --with-libxml-prefix="$PREFIX/$TARGET" \
        LIBGCRYPT_CONFIG="$PREFIX/$TARGET/bin/libgcrypt-config" \
        --without-python \
        --without-plugins
    $MAKE install bin_PROGRAMS= noinst_PROGRAMS=
    cd "$SOURCE"
    rm -rfv "libxslt-$VERSION_libxslt"
    ;;

esac


#---
#   xmlwrapp
#
#   http://sourceforge.net/projects/xmlwrapp/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=142403' |
        $SED -n 's,.*xmlwrapp-\([0-9][^>]*\)\.tgz.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_xmlwrapp=.*,VERSION_xmlwrapp=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfz "xmlwrapp-$VERSION_xmlwrapp.tgz" &>/dev/null ||
    wget -c "http://$SOURCEFORGE_MIRROR/xmlwrapp/xmlwrapp-$VERSION_xmlwrapp.tgz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/xmlwrapp-$VERSION_xmlwrapp.tgz"
    cd "xmlwrapp-$VERSION_xmlwrapp"
    EXSLT_LIBS=`$TARGET-pkg-config libexslt --libs | $SED 's,-L[^ ]*,,g'`
    $SED 's,.*/usr/include.*,,' -i configure.pl
    $SED "s,-lxslt -lexslt,$EXSLT_LIBS," -i configure.pl
    $SED 's,"ranlib",$ENV{"RANLIB"} || "ranlib",g' -i tools/cxxflags
    CXX="$TARGET-g++" \
    AR="$TARGET-ar" \
    RANLIB="$TARGET-ranlib" \
    CXXFLAGS="`$PREFIX/$TARGET/bin/xml2-config --cflags`" \
    ./configure.pl \
        --disable-shared \
        --prefix="$PREFIX/$TARGET" \
        --xml2-config="$PREFIX/$TARGET/bin/xml2-config" \
        --xslt-config="$PREFIX/$TARGET/bin/xslt-config" \
        --disable-examples
    $MAKE install
    cd "$SOURCE"
    rm -rfv "xmlwrapp-$VERSION_xmlwrapp"
    ;;

esac


#---
#   cURL
#
#   http://curl.haxx.se/libcurl/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://curl.haxx.se/changes.html' |
        $SED -n 's,.*Fixed in \([0-9][^ ]*\) - .*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_curl=.*,VERSION_curl=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfj "curl-$VERSION_curl.tar.bz2" &>/dev/null ||
    wget -c "http://curl.haxx.se/download/curl-$VERSION_curl.tar.bz2"
    ;;

--build)
    cd "$SOURCE"
    tar xfvj "$DOWNLOAD/curl-$VERSION_curl.tar.bz2"
    cd "curl-$VERSION_curl"
    $SED 's,-I@includedir@,-I@includedir@ -DCURL_STATICLIB,' -i curl-config.in
    $SED 's,GNUTLS_ENABLED = 1,GNUTLS_ENABLED=1,' -i configure
    # wine confuses the cross-compiling detection, so set it explicitly
    $SED 's,cross_compiling=no,cross_compiling=yes,' -i configure
    ./configure \
        --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET" \
        --with-gnutls="$PREFIX/$TARGET" \
        LIBS="-lgcrypt `$PREFIX/$TARGET/bin/gpg-error-config --libs`"
    $MAKE install bin_PROGRAMS= noinst_PROGRAMS=
    cd "$SOURCE"
    rm -rfv "curl-$VERSION_curl"
    ;;

esac


#---
#   libpng
#
#   http://www.libpng.org/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=5624' |
        $SED -n 's,.*libpng-\([0-9][^>]*\)-no-config\.tar.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_libpng=.*,VERSION_libpng=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfj "libpng-$VERSION_libpng.tar.bz2" &>/dev/null ||
    wget -c "http://$SOURCEFORGE_MIRROR/libpng/libpng-$VERSION_libpng.tar.bz2"
    ;;

--build)
    cd "$SOURCE"
    tar xfvj "$DOWNLOAD/libpng-$VERSION_libpng.tar.bz2"
    cd "libpng-$VERSION_libpng"
    ./configure \
        --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET"
    $MAKE install bin_PROGRAMS= noinst_PROGRAMS=
    cd "$SOURCE"
    rm -rfv "libpng-$VERSION_libpng"
    ;;

esac


#---
#   jpeg
#
#   http://www.ijg.org/
#   http://packages.debian.org/unstable/source/libjpeg6b
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://packages.debian.org/unstable/source/libjpeg6b' |
        $SED -n 's,.*libjpeg6b_\([0-9][^>]*\)\.orig\.tar.*,\1,p' | 
        tail -1`
    test -n "$VERSION"
    $SED "s,^VERSION_jpeg=.*,VERSION_jpeg=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfz "libjpeg6b_$VERSION_jpeg.orig.tar.gz" &>/dev/null ||
    wget -c "http://ftp.debian.org/debian/pool/main/libj/libjpeg6b/libjpeg6b_$VERSION_jpeg.orig.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/libjpeg6b_$VERSION_jpeg.orig.tar.gz"
    cd "jpeg-$VERSION_jpeg"
    ./configure \
        CC="$TARGET-gcc" RANLIB="$TARGET-ranlib" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET"
    $MAKE install-lib
    cd "$SOURCE"
    rm -rfv "jpeg-$VERSION_jpeg"
    ;;

esac


#---
#   LibTIFF
#
#   http://www.remotesensing.org/libtiff/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://www.remotesensing.org/libtiff/' |
        $SED -n 's,.*>v\([0-9][^<]*\)<.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_tiff=.*,VERSION_tiff=$VERSION," -i "$0"
    ;;

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
        --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET" \
        PTHREAD_LIBS="-lpthread -lws2_32" \
        --without-x
    $MAKE install bin_PROGRAMS= noinst_PROGRAMS=
    cd "$SOURCE"
    rm -rfv "tiff-$VERSION_tiff"
    ;;

esac


#---
#   giflib
#
#   http://sourceforge.net/projects/libungif/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=102202' |
        $SED -n 's,.*giflib-\([0-9][^>]*\)\.tar.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_giflib=.*,VERSION_giflib=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfj "giflib-$VERSION_giflib.tar.bz2" &>/dev/null ||
    wget -c "http://$SOURCEFORGE_MIRROR/libungif/giflib-$VERSION_giflib.tar.bz2"
    ;;

--build)
    cd "$SOURCE"
    tar xfvj "$DOWNLOAD/giflib-$VERSION_giflib.tar.bz2"
    cd "giflib-$VERSION_giflib"
    $SED 's,u_int32_t,unsigned int,' -i configure
    ./configure \
        --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET" \
        --without-x
    $MAKE install -C lib
    cd "$SOURCE"
    rm -rfv "giflib-$VERSION_giflib"
    ;;

esac


#---
#   freetype
#
#   http://freetype.sourceforge.net/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=3157' |
        $SED -n 's,.*freetype-\([2-9][^>]*\)\.tar.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_freetype=.*,VERSION_freetype=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfj "freetype-$VERSION_freetype.tar.bz2" &>/dev/null ||
    wget -c "http://$SOURCEFORGE_MIRROR/freetype/freetype-$VERSION_freetype.tar.bz2"
    ;;

--build)
    cd "$SOURCE"
    tar xfvj "$DOWNLOAD/freetype-$VERSION_freetype.tar.bz2"
    cd "freetype-$VERSION_freetype"
    GNUMAKE=$MAKE \
    ./configure \
        --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET"
    $MAKE install
    cd "$SOURCE"
    rm -rfv "freetype-$VERSION_freetype"
    ;;

esac


#---
#   fontconfig
#
#   http://fontconfig.org/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://fontconfig.org/release/' |
        $SED -n 's,.*fontconfig-\([0-9][^>]*\)\.tar.*,\1,p' | 
        tail -1`
    test -n "$VERSION"
    $SED "s,^VERSION_fontconfig=.*,VERSION_fontconfig=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfz "fontconfig-$VERSION_fontconfig.tar.gz" &>/dev/null ||
    wget -c "http://fontconfig.org/release/fontconfig-$VERSION_fontconfig.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/fontconfig-$VERSION_fontconfig.tar.gz"
    cd "fontconfig-$VERSION_fontconfig"
    $SED 's,^install-data-local:.*,install-data-local:,' -i src/Makefile.in
    ./configure \
        --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET" \
        --with-arch="" \
        --with-freetype-config="$PREFIX/$TARGET/bin/freetype-config" \
        --enable-libxml2 \
        LIBXML2_CFLAGS="`$PREFIX/$TARGET/bin/xml2-config --cflags`" \
        LIBXML2_LIBS="`$PREFIX/$TARGET/bin/xml2-config --libs`"
    $MAKE install -C src
    $MAKE install -C fontconfig
    cd "$SOURCE"
    rm -rfv "fontconfig-$VERSION_fontconfig"
    ;;

esac


#---
#   libMikMod
#
#   http://mikmod.raphnet.net/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://mikmod.raphnet.net/' |
        $SED -n 's,.*libmikmod-\([0-9][^>]*\)\.tar.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_libmikmod=.*,VERSION_libmikmod=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfj "libmikmod-$VERSION_libmikmod.tar.bz2" &>/dev/null ||
    wget -c "http://mikmod.raphnet.net/files/libmikmod-$VERSION_libmikmod.tar.bz2"
    ;;

--build)
    cd "$SOURCE"
    tar xfvj "$DOWNLOAD/libmikmod-$VERSION_libmikmod.tar.bz2"
    cd "libmikmod-$VERSION_libmikmod"
    $SED 's,-Dunix,,' -i libmikmod/Makefile.in
    CC="$TARGET-gcc" \
    NM="$TARGET-nm" \
    RANLIB="$TARGET-ranlib" \
    STRIP="$TARGET-strip" \
    LIBS="-lws2_32" \
    ./configure \
        --disable-shared \
        --prefix="$PREFIX/$TARGET" \
        --disable-esd
    $MAKE install bin_PROGRAMS= noinst_PROGRAMS=
    cd "$SOURCE"
    rm -rfv "libmikmod-$VERSION_libmikmod"
    ;;

esac


#---
#   OGG
#
#   http://www.xiph.org/ogg/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://www.xiph.org/downloads/' |
        $SED -n 's,.*libogg-\([0-9][^>]*\)\.tar.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_ogg=.*,VERSION_ogg=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfz "libogg-$VERSION_ogg.tar.gz" &>/dev/null ||
    wget -c "http://downloads.xiph.org/releases/ogg/libogg-$VERSION_ogg.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/libogg-$VERSION_ogg.tar.gz"
    cd "libogg-$VERSION_ogg"
    # wine confuses the cross-compiling detection, so set it explicitly
    $SED 's,cross_compiling=no,cross_compiling=yes,' -i configure
    ./configure \
        --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET"
    $MAKE install bin_PROGRAMS= noinst_PROGRAMS=
    cd "$SOURCE"
    rm -rfv "libogg-$VERSION_ogg"
    ;;

esac


#---
#   Vorbis
#
#   http://www.vorbis.com/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://www.xiph.org/downloads/' |
        $SED -n 's,.*libvorbis-\([0-9][^>]*\)\.tar.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_vorbis=.*,VERSION_vorbis=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfz "libvorbis-$VERSION_vorbis.tar.gz" &>/dev/null ||
    wget -c "http://downloads.xiph.org/releases/vorbis/libvorbis-$VERSION_vorbis.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/libvorbis-$VERSION_vorbis.tar.gz"
    cd "libvorbis-$VERSION_vorbis"
    ./configure \
        --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET" \
        PKG_CONFIG="$TARGET-pkg-config" \
        LIBS="-lws2_32"
    $MAKE install bin_PROGRAMS= noinst_PROGRAMS=
    cd "$SOURCE"
    rm -rfv "libvorbis-$VERSION_vorbis"
    ;;

esac


#---
#   GD
#   (without support for xpm)
#
#   http://www.libgd.org/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://www.libgd.org/releases/' |
        $SED -n 's,.*gd-\([0-9][^>]*\)\.tar.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_gd=.*,VERSION_gd=$VERSION," -i "$0"
    ;;

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
    $SED 's,-I@includedir@,-I@includedir@ -DNONDLL,' -i config/gdlib-config.in
    $SED 's,-lX11 ,,g' -i configure
    ./configure \
        --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET" \
        --with-freetype="$PREFIX/$TARGET" \
        --without-x \
        LIBPNG12_CONFIG="$PREFIX/$TARGET/bin/libpng12-config" \
        LIBPNG_CONFIG="$PREFIX/$TARGET/bin/libpng-config" \
        CFLAGS="-DNONDLL -DXMD_H -L$PREFIX/$TARGET/lib" \
        LIBS="`$PREFIX/$TARGET/bin/xml2-config --libs`"
    $MAKE install bin_PROGRAMS= noinst_PROGRAMS=
    cd "$SOURCE"
    rm -rfv "gd-$VERSION_gd"
    ;;

esac


#---
#   SDL
#
#   http://www.libsdl.org/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://www.libsdl.org/release/changes.html' |
        $SED -n 's,.*SDL \([0-9][^>]*\) Release Notes.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_SDL=.*,VERSION_SDL=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfz "SDL-$VERSION_SDL.tar.gz" &>/dev/null ||
    wget -c "http://www.libsdl.org/release/SDL-$VERSION_SDL.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/SDL-$VERSION_SDL.tar.gz"
    cd "SDL-$VERSION_SDL"
    $SED 's,-mwindows,-lwinmm -mwindows,' -i configure
    ./configure \
        --host="$TARGET" \
        --disable-shared \
        --disable-debug \
        --prefix="$PREFIX/$TARGET"
    $MAKE install bin_PROGRAMS= noinst_PROGRAMS=
    cd "$SOURCE"
    rm -rfv "SDL-$VERSION_SDL"
    ;;

esac


#---
#   smpeg
#
#   http://icculus.org/smpeg/
#   http://packages.debian.org/unstable/source/smpeg
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://packages.debian.org/unstable/source/smpeg' |
        $SED -n 's,.*smpeg_\([0-9][^>]*\)\.orig\.tar.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_smpeg=.*,VERSION_smpeg=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfz "smpeg_$VERSION_smpeg.orig.tar.gz" &>/dev/null ||
    wget -c "http://ftp.debian.org/debian/pool/main/s/smpeg/smpeg_$VERSION_smpeg.orig.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/smpeg_$VERSION_smpeg.orig.tar.gz"
    cd "smpeg-$VERSION_smpeg.orig"
    ./configure \
        --host="$TARGET" \
        --disable-shared \
        --disable-debug \
        --prefix="$PREFIX/$TARGET" \
        --with-sdl-prefix="$PREFIX/$TARGET" \
        --disable-sdltest \
        --disable-gtk-player \
        --disable-opengl-player
    $MAKE install bin_PROGRAMS= noinst_PROGRAMS=
    cd "$SOURCE"
    rm -rfv "smpeg-$VERSION_smpeg.orig"
    ;;

esac


#---
#   SDL_mixer
#
#   http://www.libsdl.org/projects/SDL_mixer/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://www.libsdl.org/projects/SDL_mixer/' |
        $SED -n 's,.*SDL_mixer-\([0-9][^>]*\)\.tar.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_SDL_mixer=.*,VERSION_SDL_mixer=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfz "SDL_mixer-$VERSION_SDL_mixer.tar.gz" &>/dev/null ||
    wget -c "http://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-$VERSION_SDL_mixer.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/SDL_mixer-$VERSION_SDL_mixer.tar.gz"
    cd "SDL_mixer-$VERSION_SDL_mixer"
    $SED 's,for path in /usr/local; do,for path in; do,' -i configure
    ./configure \
        --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET" \
        --with-sdl-prefix="$PREFIX/$TARGET" \
        --disable-sdltest \
        --enable-music-libmikmod \
        --enable-music-ogg \
        --disable-music-ogg-shared \
        --with-smpeg-prefix="$PREFIX/$TARGET" \
        --disable-smpegtest \
        --disable-music-mp3-shared
    $MAKE install bin_PROGRAMS= noinst_PROGRAMS=
    cd "$SOURCE"
    rm -rfv "SDL_mixer-$VERSION_SDL_mixer"
    ;;

esac


#---
#   SDL_image
#
#   http://www.libsdl.org/projects/SDL_image/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://www.libsdl.org/projects/SDL_image/' |
        $SED -n 's,.*SDL_image-\([0-9][^>]*\)\.tar.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_SDL_image=.*,VERSION_SDL_image=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfz "SDL_image-$VERSION_SDL_image.tar.gz" &>/dev/null ||
    wget -c "http://www.libsdl.org/projects/SDL_image/release/SDL_image-$VERSION_SDL_image.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/SDL_image-$VERSION_SDL_image.tar.gz"
    cd "SDL_image-$VERSION_SDL_image"
    ./configure \
        --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET" \
        --with-sdl-prefix="$PREFIX/$TARGET" \
        --disable-sdltest \
        --disable-jpg-shared \
        --disable-png-shared \
        --disable-tif-shared
    $MAKE install bin_PROGRAMS= noinst_PROGRAMS=
    cd "$SOURCE"
    rm -rfv "SDL_image-$VERSION_SDL_image"
    ;;

esac


#---
#   FLTK
#
#   http://www.fltk.org/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://www.fltk.org/' |
        $SED -n 's,.*>v\([0-9][^<]*\)<.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_fltk=.*,VERSION_fltk=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfj "fltk-$VERSION_fltk-source.tar.bz2" &>/dev/null ||
    wget -c "http://ftp.easysw.com/pub/fltk/$VERSION_fltk/fltk-$VERSION_fltk-source.tar.bz2"
    ;;

--build)
    cd "$SOURCE"
    tar xfvj "$DOWNLOAD/fltk-$VERSION_fltk-source.tar.bz2"
    cd "fltk-$VERSION_fltk"
    $SED 's,\$uname,MINGW,g' -i configure
    # wine confuses the cross-compiling detection, so set it explicitly
    $SED 's,cross_compiling=no,cross_compiling=yes,' -i configure
    ./configure \
        --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET" \
        --enable-threads \
        LIBS="-lws2_32"
    $MAKE install DIRS=src
    cd "$SOURCE"
    rm -rfv "fltk-$VERSION_fltk"
    ;;

esac


#---
#   GEOS
#
#   http://geos.refractions.net/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://geos.refractions.net/' |
        $SED -n 's,.*geos-\([0-9][^>]*\)\.tar.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_geos=.*,VERSION_geos=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfj "geos-$VERSION_geos.tar.bz2" &>/dev/null ||
    wget -c "http://geos.refractions.net/geos-$VERSION_geos.tar.bz2"
    ;;

--build)
    cd "$SOURCE"
    tar xfvj "$DOWNLOAD/geos-$VERSION_geos.tar.bz2"
    cd "geos-$VERSION_geos"
    $SED 's,-lgeos,-lgeos -lstdc++,' -i tools/geos-config.in
    # timezone and gettimeofday are in <time.h> since MinGW runtime 3.10
    $SED 's,struct timezone {,struct timezone_disabled {,' -i source/headers/geos/timeval.h
    $SED 's,int gettimeofday,int gettimeofday_disabled,'   -i source/headers/geos/timeval.h
    ./configure \
        --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET" \
        --disable-swig
    $MAKE install bin_PROGRAMS= noinst_PROGRAMS=
    cd "$SOURCE"
    rm -rfv "geos-$VERSION_geos"
    ;;

esac


#---
#   proj
#
#   http://www.remotesensing.org/proj/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://www.remotesensing.org/proj/' |
        $SED -n 's,.*proj-\([0-9][^>]*\)\.tar.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_proj=.*,VERSION_proj=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfz "proj-$VERSION_proj.tar.gz" &>/dev/null ||
    wget -c "ftp://ftp.remotesensing.org/proj/proj-$VERSION_proj.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/proj-$VERSION_proj.tar.gz"
    cd "proj-$VERSION_proj"
    $SED 's,install-exec-local[^:],,' -i src/Makefile.in
    ./configure \
        --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET"
    $MAKE install bin_PROGRAMS= noinst_PROGRAMS=
    cd "$SOURCE"
    rm -rfv "proj-$VERSION_proj"
    ;;

esac


#---
#   GeoTiff
#
#   http://www.remotesensing.org/geotiff/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://www.remotesensing.org/geotiff/geotiff.html' |
        $SED -n 's,.*libgeotiff-\([0-9][^>]*\)\.tar.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_libgeotiff=.*,VERSION_libgeotiff=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfz "libgeotiff-$VERSION_libgeotiff.tar.gz" &>/dev/null ||
    wget -c "ftp://ftp.remotesensing.org/pub/geotiff/libgeotiff/libgeotiff-$VERSION_libgeotiff.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/libgeotiff-$VERSION_libgeotiff.tar.gz"
    cd "libgeotiff-$VERSION_libgeotiff"
    $SED 's,/usr/local,@prefix@,' -i bin/Makefile.in
    touch configure
    ./configure \
        --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET"
    $MAKE all install EXEEXT=.remove-me
    rm -fv "$PREFIX/$TARGET"/bin/*.remove-me
    cd "$SOURCE"
    rm -rfv "libgeotiff-$VERSION_libgeotiff"
    ;;

esac


#---
#   GDAL
#
#   http://www.gdal.org/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://trac.osgeo.org/gdal/wiki/DownloadSource' |
        $SED -n 's,.*gdal-\([0-9][^>]*\)\.tar.*,\1,p' | 
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_gdal=.*,VERSION_gdal=$VERSION," -i "$0"
    ;;

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
        --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET" \
        LIBS="-ljpeg" \
        --with-png="$PREFIX/$TARGET" \
        --with-libtiff="$PREFIX/$TARGET" \
        --with-geotiff="$PREFIX/$TARGET" \
        --with-jpeg="$PREFIX/$TARGET" \
        --with-gif="$PREFIX/$TARGET" \
        --with-curl="$PREFIX/$TARGET/bin/curl-config" \
        --with-geos="$PREFIX/$TARGET/bin/geos-config" \
        --without-python \
        --without-ngpython
    $MAKE lib-target
    $MAKE install-lib
    $MAKE install -C port
    $MAKE install -C gcore
    $MAKE install -C frmts
    $MAKE install -C alg
    $MAKE install -C ogr  OGR_ENABLED=
    $MAKE install -C apps BIN_LIST=
    cd "$SOURCE"
    rm -rfv "gdal-$VERSION_gdal"
    ;;

esac


#---
#   PDFlib Lite
#
#   http://www.pdflib.com/download/pdflib-family/pdflib-lite/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://www.pdflib.com/download/pdflib-family/pdflib-lite/' |
        $SED -n 's,.*PDFlib-Lite-\([0-9][^>]*\)\.tar.*,\1,p' |
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_pdflib_lite=.*,VERSION_pdflib_lite=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    DIR=`echo $VERSION_pdflib_lite | $SED 's,[^0-9],,g'`
    tar tfz "PDFlib-Lite-$VERSION_pdflib_lite.tar.gz" &>/dev/null ||
    wget -c "http://www.pdflib.com/binaries/PDFlib/$DIR/PDFlib-Lite-$VERSION_pdflib_lite.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/PDFlib-Lite-$VERSION_pdflib_lite.tar.gz"
    cd "PDFlib-Lite-$VERSION_pdflib_lite"
    $SED 's,ac_sys_system=`uname -s`,ac_sys_system=MinGW,' -i configure
    ./configure \
        --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET" \
        --with-pnglib="$PREFIX/$TARGET" \
        --with-tifflib="$PREFIX/$TARGET" \
        --with-zlib="$PREFIX/$TARGET" \
        --without-java \
        --without-py \
        --without-perl \
        --without-ruby \
        --without-tcl \
        --disable-php \
        --enable-cxx \
        --enable-large-files \
        --with-openssl
    $SED 's,-DPDF_PLATFORM=[^ ]* ,,' -i config/mkcommon.inc
    $MAKE all install -C libs
    cd "$SOURCE"
    rm -rfv "PDFlib-Lite-$VERSION_pdflib_lite"
    ;;

esac


#---
#   libowfat
#
#   http://www.fefe.de/libowfat/
#---

case "$1" in

--new-versions)
    VERSION=`
        wget -q -O- 'http://www.fefe.de/libowfat/' |
        $SED -n 's,.*libowfat-\([0-9][^>]*\)\.tar.*,\1,p' |
        head -1`
    test -n "$VERSION"
    $SED "s,^VERSION_libowfat=.*,VERSION_libowfat=$VERSION," -i "$0"
    ;;

--download)
    cd "$DOWNLOAD"
    tar tfj "libowfat-$VERSION_libowfat.tar.bz2" &>/dev/null ||
    wget -c "http://dl.fefe.de/libowfat-$VERSION_libowfat.tar.bz2"
    ;;

--build)
    cd "$SOURCE"
    tar xfvj "$DOWNLOAD/libowfat-$VERSION_libowfat.tar.bz2"
    cd "libowfat-$VERSION_libowfat"
    $MAKE Makefile -f GNUmakefile \
        CROSS="$TARGET-" \
        prefix="$PREFIX/$TARGET" \
        INCLUDEDIR="$PREFIX/$TARGET/include/libowfat" \
        DIET=
    $MAKE install \
        CROSS="$TARGET-" \
        prefix="$PREFIX/$TARGET" \
        INCLUDEDIR="$PREFIX/$TARGET/include/libowfat" \
        DIET=
    cd "$SOURCE"
    rm -rfv "libowfat-$VERSION_libowfat"
    ;;

esac


#---
#   Create package
#---

case "$1" in

--build)
    cd "$PREFIX"
    tar cfv - \
        bin \
        lib \
        libexec \
        "$TARGET/bin" \
        "$TARGET/include" \
        "$TARGET/lib" \
    | gzip -9 >"$ROOT/mingw_cross_env.tar.gz"
    ;;

esac
