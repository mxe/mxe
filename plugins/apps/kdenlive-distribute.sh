#!/bin/bash -xe
# run from mxe root dir after "make kdenlive"
# > plugins/apps/kdenlive-distribute.sh
MXE_DIR=$PWD

VERSION=$(sed -n 's/.*VERSION\s*:=\s*//p' $MXE_DIR/plugins/apps/kdenlive.mk)
INSTALL_DIR=$MXE_DIR/../Kdenlive-$VERSION
echo Installing to $INSTALL_DIR
[ -d $INSTALL_DIR ] && echo "... already exists, delete?" && rm -rI $INSTALL_DIR
mkdir -p $INSTALL_DIR/{lib,share,etc}

MXE_BINDIR=$MXE_DIR/usr/x86_64-w64-mingw32.shared.posix
cd $MXE_BINDIR

echo Copying binaries
cp *.dll *.exe $INSTALL_DIR
cp bin/{*.dll,ff*.exe,kdenlive*.exe,kioslave.exe,dbus-daemon.exe,qtlogging.ini} $INSTALL_DIR
rm $INSTALL_DIR/icu*5*.dll
cp lib/libdl.dll.a $INSTALL_DIR
cp qt5/bin/*.dll $INSTALL_DIR
cp -r qt5/{plugins,qml} $INSTALL_DIR
echo Copying data
cp -r bin/data $INSTALL_DIR
cp bin/data/icons/breeze/breeze-icons.rcc $INSTALL_DIR/data/icontheme.rcc
rm -r $INSTALL_DIR/data/icons/
# MLT looks for lib & share next to exe on windows
cp -r share/{mlt,ffmpeg,dbus-1} $INSTALL_DIR/share
cp -r etc/{dbus-1,xdg} $INSTALL_DIR/etc
cp -r lib/{mlt,frei0r-1,ladspa} $INSTALL_DIR/lib
printf "[Paths]\nPlugins=plugins\nQml2Imports=qml\n" > $INSTALL_DIR/qt.conf

# Qt finds local data directly in /data, not in /data/kdenlive
mv $INSTALL_DIR/data/kdenlive/* $INSTALL_DIR/data/
rmdir $INSTALL_DIR/data/kdenlive

# Copy KDE's color schemes from system
cp -r /usr/share/color-schemes $INSTALL_DIR/data
# MXE's libwinpthread is broken
cp /usr/x86_64-w64-mingw32/lib/libwinpthread-1.dll $INSTALL_DIR

cp $MXE_DIR/tmp-kdenlive*/kdenlive-*/{AUTHORS,COPYING,README} $INSTALL_DIR
if [ -$1 == -z ]
then
    echo "Compressing"
    cd $INSTALL_DIR/..
    7z a $INSTALL_DIR-w64.7z $INSTALL_DIR
    cd $MXE_BINDIR/bin
    7z a $MXE_DIR/../Kdenlive-$VERSION-w64dbg.7z kdenlive.debug
fi

