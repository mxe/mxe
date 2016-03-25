#!/bin/bash

# This script belongs to MXE Project
# It describes how to use copydlldeps.sh
# 
# In this example, you will see how to compile a Qt5 example with MXE
# It will create a shared build and copy all dependencies to the OUTDIR
# The *exe is also copied to OUTDIR, so you can move it to your computer and launch it
#
# Contributed by Lars Holger Engelhard - DL5RCW


# Edit according to your system
MXEDIR=/home/mxeuser/mxe
OUTDIR=/home/mxeuser/public_html/buildartefacts
# Choose which compiler to use
#TARGET=i686-w64-mingw32.shared
TARGET=x86_64-w64-mingw32.shared

echo "create a temp directory called ${TEMPDIR}"
TEMPDIR=$( mktemp -d )

#store current directory, so we can return at the very end
CURDIR=$( pwd )
echo "Building example cube"
echo "create a temp directory called ${TEMPDIR}"
mkdir ${TEMPDIR}

echo "copy an example into the temp directory ${TEMPDIR}"
cp ${MXEDIR}/pkg/qtbase-opensource-src-5.5.1 ${TEMPDIR}/

echo "step into the directory ${TEMPDIR}"
cd ${TEMPDIR}
echo $( pwd )
sleep 2

echo "extract the package qtbase-opensource-src-5.5.1 in ${TEMPDIR}"
tar xf ${TEMPDIR}/qtbase-opensource-src-5.5.1.tar.xz

echo "step into the example folder and to a project folder cube"
cd ${TEMPDIR}/qtbase-opensource-src-5.5.1/examples/opengl/cube 


echo "prepare the environment to build cube"
export PATH=${MXEDIR}/usr/bin/:$PATH

echo "creating the makefile with qmake cube.pro"
${MXEDIR}/usr/bin/${TARGET}-qmake-qt5 cube.pro 

echo "start the build"
make

echo "create a destination folder"
mkdir ${MXEDIR}/buildartefacts/cube

echo "start the dependency search"
${MXEDIR}/tools/copydlldeps.sh --destdir ${OUTDIR}/cube/ --infile release/cube.exe  --recursivesrcdir /share/mxe/usr/${TARGET}/ --enforcedir ${MXEDIR}/usr/${TARGET}/qt5/plugins/platforms/ 


echo "copy the *exe file to the destdir"
cp ${TEMPDIR}/qtbase-opensource-src-5.5.1/examples/opengl/cube/release/cube.exe ${OUTDIR}/cube/

echo "stepping back into ${CURDIR}"
cd $CURDIR

echo "clean up our working environment"
rm -rf ${TEMPDIR}

exit 0
