README of copydlldeps.sh
========================
This document belongs to copydlldeps.sh and is a part of the MXE project.

It can be invoked on the command line like:

```
/share/mxe/tools/copydlldeps.sh --infile /home/mxeuser/test/i686-w64-mingw32.shared/Application.exe \
                --destdir /home/mxeuser/testdlls/   \
                --recursivesrcdir /home/mxeuser/mxe/usr/i686-w64-mingw32.shared/ \
                --srcdir /home/mxeuser/test/ \
                --copy \
                --enforcedir /home/mxeuser/mxe/usr/i686-w64-mingw32.shared/qt5/plugins/platforms/ \
                --objdump /home/mxeuser/mxe/usr/bin/i686-w64-mingw32.shared-objdump
```

It got embedded in a build script like:

```
MXEPATH=/path/to/mxe
compiler=i686-w64-mingw32.shared
orgDir=/path/to/my/nsis/dll # nsis is then copying all dlls in there to the place where the exe is located

if [ ! $( echo $compiler | grep -q "shared" ) ]; then
    echo "\$compiler=$compiler and contains the word 'shared'" | tee -a $CURLOG

    echo "+-----------------------------------------------+ " | tee -a $CURLOG
    echo "| Starting new MXE copydlldeps.sh by LHE DL5RCW | " | tee -a $CURLOG
    echo "+-----------------------------------------------+ " | tee -a $CURLOG
    echo "currently working in $( pwd ) " | tee -a $CURLOG
    executable=$( find . -name "*.exe" | tail -n 1 )
    sharedLibsDir="${orgDir}/nsis/sharedLibs"
    echo "populating dir $sharedLibsDir with dll dependencies of $executable" | tee -a $CURLOG
    OBJDUMP=objdump
    if [ -e "$MXEPATH/usr/bin/$compiler-objdump" ]; then
        OBJDUMP="$MXEPATH/usr/bin/$compiler-objdump"
    fi
    $MXEPATH/tools/copydlldeps.sh     --infile $executable \
                    --destdir "$sharedLibsDir" \
                    --recursivesrcdir "$MXEPATH/usr/$compiler/" \
                    --enforcedir "$MXEPATH/usr/$compiler/qt5/plugins/platforms/" \
                    --copy \
                    --objdump "$OBJDUMP" \
                    | tee -a $CURLOG
fi
```

Additional hints
================

objdump
-------
I checked if there is a mxe objdump. If not, I took the native one on my server.
I actually do not know the difference but decided to include it in the script
in case it is important to someone.

whitelist
---------
I added a whitelist of *dll files that are widely used and very common on windows systems. Most of them are not to be found on MXE, but on native machines. As they are listed as dependencies, they might create warnings. To avoid anxiety, I introduced str_whiteListDlls. Those will create info instead of warning messages. Do not worry about them any longer. It works anyway as those are to be expected on your windows installation.

exclude directory pattern
-------------------------
excludedir was added as an aditional option. You may call it multiple times like
    --excludepattern /path/folder1/ --excludepattern /path/folder2/ -X /path/folder3/
Try to make it as explicit as possible. If you choose a generic pattern, you may exclude more paths than you intend to. Actually any pattern will work.
    -X pattern1 -X pattern2
This was introduced upon the request to have the script avoid /(PREFIX)/(TARGET)/apps/. You may now pass this as an 'excludepattern' option.

enforcedir
----------
My application is using Qt5 and objdump did not return the needed qwindows.dll -
so I enforce the platform folder. You may add multiple --enforcedir directories using
`--enforcedir /path/folder1 --enforcedir /path/folder2 --enforcedir /path/folder3`.

They are NOT recursively copied, only flat. See:

```bash
    string=$( find $enforcedDirectory -maxdepth 1 -iregex '.*\(dll\|exe\)' | tr '\n' ' ' )
```

If you would remove the `-maxdepth 1`, it would become recoursive.

February, 2, 2016. Lars Holger Engelhard aka [DL5RCW](https://github.com/dl5rcw).
