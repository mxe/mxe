== README of copydlldeps.sh ==
This document was created 2016-02-05. It belongs to copydlldeps.sh

I call it on the command line like:
<source lang="bash">
/share/mxe/tools/copydlldeps.sh --infile /home/mxeuser/test/i686-w64-mingw32.shared/Application.exe \
				--destdir /home/mxeuser/testdlls/   \
				--recursivesrcdir /home/mxeuser/mxe/usr/i686-w64-mingw32.shared/ \
				--srcdir /home/mxeuser/test/ \
				--copy \
				--enforce /home/mxeuser/mxe/usr/i686-w64-mingw32.shared/qt5/plugins/platforms/ \
				--objdump /home/mxeuser/mxe/usr/bin/i686-w64-mingw32.shared-objdump
</source>
It got embedded in a build script like:

<source lang="bash">
MXEPATH=/path/to/mxe
compiler=i686-w64-mingw32.shared
orgDir=/path/to/my/nsis/dll #nsis is then copying all dlls in there to the place where the exe is located

if [ ! $( echo $compiler | grep -q "shared" ) ]; then
	echo "\$compiler=$compiler and contains the word 'shared'" | tee -a $CURLOG

	echo "#===============================================# " | tee -a $CURLOG
	echo "| Starting new MXE copydlldeps.sh by LHE DL5RCW | " | tee -a $CURLOG
	echo "#===============================================# " | tee -a $CURLOG
	echo "currently working in $( pwd ) " | tee -a $CURLOG
	executable=$(  find . -name "*.exe" | tail -n 1 )
if [ -e $MXEPATH/usr/bin/$compiler-objdump ]; then
	echo "now populating dir=${orgDir}/nsis/sharedLibs with dll dependencies of executable=$executable" | tee -a $CURLOG
	$MXEPATH/tools/copydlldeps.sh 	--infile $executable \
					--destdir ${orgDir}/nsis/sharedLibs \
					--recursivesrcdir $MXEPATH/usr/$compiler/ \
					--enforce $MXEPATH/usr/$compiler/qt5/plugins/platforms/ \
					--copy \
					--objdump $MXEPATH/usr/bin/$compiler-objdump | tee -a $CURLOG
else
	echo "now populating dir=${orgDir}/nsis/sharedLibs with dll dependencies of executable=$executable" | tee -a $CURLOG
	$MXEPATH/tools/copydlldeps.sh 	--infile $executable \
					--destdir ${orgDir}/nsis/sharedLibs \
					--recursivesrcdir $MXEPATH/usr/$compiler/ \
					--enforce $MXEPATH/usr/$compiler/qt5/plugins/platforms/ \
					--copy | tee -a $CURLOG
fi
</source>


== Additional hints ==
=== objdump ===
I checked if there is a mxe objdump. If not, I took the native one on my server. I actually do not know the difference but decided to include it in the script in case it is important to someone
=== enforce ===
My application is using Qt5 and objdump did not return the needed qwindows.dll - so I enforce the platform folder. You may add multiple --enforce directories using --enforce /path/folder1 --enforce /path/folder2 --enforce /path/folder3
They are NOT recursively copied, only flat. See:
    string=$( find $enforcedDirectory -maxdepth 1 -iregex '.*\(dll\|exe\)' | tr '\n' ' ' )

If you would remove the -maxdepth 1, it would become recoursive. Does anyone need that? 


