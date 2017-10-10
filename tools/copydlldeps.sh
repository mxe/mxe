#!/usr/bin/env bash
#

# print version and license
# is hereby part of the code and also displayed to the user
version() {
    cat <<EOF >&2

Welcome to $( basename $0)!
Authors:  Lars Holger Engelhard - DL5RCW (2016)
          Tiancheng "Timothy" Gu (2014)

Version: 1.3

# This file is part of the MXE Project, sponsored by the named authors
# it supports the shared build approach by providing an easy way to
# check for library dependencies in a recursive manner

# Copyright (c) 2016 Lars Holger Engelhard - DL5RCW
#           (c) 2014 Tiancheng "Timothy" Gu

#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject
# to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

EOF
}

# default application objdump
# you can specify your own objdump with --objdump or -o
OBJDUMP=objdump

# create a temp directory
tmp=$( mktemp -d )

# print an help menu
help() {
    cat <<EOF >&2


Usage: $0 -c    -d DEST -s SRC [-f FILE|-F DIR]
  or:  $0    -p                [-f FILE|-F DIR]
  or:  $0 -c -p -d DEST -s SRC [-f FILE|-F DIR]
  or:  $0    -p -d DEST -R SRC [-f FILE|-F DIR]
  or:  $0    -p -d DEST -S "SRC_1 SRC_2 ... SRC_n" [-f FILE|-F DIR]
  or:  $0 -c    -d DEST -R SRC_1 -e SRC_2          [-f FILE|-F DIR]


Copy executable FILE(s) and their DLL dependencies for SRC directory to a
DEST directory, and/or print the recursive dependencies.

Operating modes:
  -c, --copy              print and copy dependencies
  -p, --print             print dependencies (no copy action)

Operating options:
  -d, --destdir           Destination directory - a single destination folder
  -f, --infile            [ multiCall ] The input executable file or DLL.
  -F, --infiles, --indir  [ multiCall ] The input directory of executable files and/or DLLs.
  -s, --srcdir            [ multiCall ] The directory with DLLs that can be copied.
  -S, --srcdirs           [ multiCall ] List of directories with DLLs that can be copied. Put "" around them, e.g. "/dir1 /root/dir2 /root/dir3"
  -R, --recursivesrcdir   [ multiCall ] Target directory for recursive search of folders containing *dll files
  -X, --excludepattern    [ multiCall ] Exclude any path that contains such pattern, e.g. /(PREFIX)/(TARGET)/apps/

Optional binary settings:
  -o, --objdump           Specify the path or name of your objdump application
  -e, --enforcedir        [ multiCall ] Enforce executable files and/or DLLs of a specific directory
                          It will be entirely copied - flat, non recursive. assumes *.dll and *.exe in the top level directory
                       It will copy those into a directory in DESTDIR!
                          e.g. <path_to_mxe>/mxe/usr/<compiler>/qt5/plugins/platforms/ - for qwindows.dll becomes
                          DESTDIR/platforms/ containing qwindows.dll
Other options:
  -h,-H, --help           Display this message and exit
  -v,-V, --version        Display version of this application
  -l,-L, --loglevel       Display more output - default is 1

multiCall => you can specify this option multiple times!

Authors:  Lars Holger Engelhard - DL5RCW
          Tiancheng "Timothy" Gu
EOF
}

# terminate the application
# print an error message
# and clean the tmp directory
die() {
    echo $1 >&2
    rm -rf "$tmp"
    help
    exit 1
}

# find all directories containing dll files
# you can pass a list (array) of directories
# and findAllSrcDirectories will hunt for dlls in each one recursively
# it will return a sorted list and duplicates are removed
findAllSrcDirectories(){
    ar_recursiveDirList=${!1}
    string=""
    for curPath in "${ar_recursiveDirList[@]}"; do
        for element in $(find $curPath $excludePattern -iname "*.dll"); do
            #ar_list+="$(dirname $element) "
            string+="$(dirname $element) "
        done
    done
    string=$(echo "$string" | tr -s ' ' | tr ' ' '\n' | nl | sort -u -k2 | sort -n | cut -f2-)
    echo $string #returns the string
}

while [ $# -gt 0 ]; do
    key="$1"
    shift

    case $key in
    -f|--infile)
        infile+=" $1"
        shift
        ;;
    -F|--indir|--infiles)
        indir+=" $1"
        shift
        ;;
    -s|--srcdir)
        srcdir+=" $1"
        shift
        ;;
    -d|--destdir)
        destdir="$1"
        shift
        ;;
    -S|--srcdirs)
        srcdirs+=" $1"
        shift
        ;;
    -R|--recursivesrcdir)
        recursivesrcdir+=" $1"
        shift
        ;;
    -X|--excludepattern)
        excludepattern+=" $1"
        shift
        ;;
    -o|--objdump)
        OBJDUMP="$1"
        shift
        ;;
    -e|--enforcedir)
        enforcedir+=" $1"
        shift
        ;;
    -l|-L|--loglevel)
        loglevel="$1"
        shift
        ;;
    -p|--print)
        opmode="print"
        ;;
    -c|--copy)
        opmode="copy"
        ;;
    -h|-H|--help)
        help
        exit 0
        ;;
    -v|-V|--version)
        version
        exit 0
        ;;
    *)
        echo "unknown option $key ignored" >&2
        ;;
    esac
done

# setting default values if no arguments were given
if ! [ "$loglevel" ]; then
    loglevel=0
fi

if ! [ "$opmode" ]; then
    opmode="copy"      # used as default in productive
    #opmode="print"     # used as default in development
fi

if ! [ "$destdir" ]; then
    die '--destdir is not specified.'
fi

if [ -n "$(ls -A $destdir 2>/dev/null)" ]; then
    echo 'Warning: --destdir already exists and contains files.' >&2
else
    mkdir -p "$destdir"
    echo "info: created --destdir $destdir"
fi

if [ "$loglevel" -gt 1 ]; then
    echo "filelist=$filelist"
    echo "opmode=$opmode"
fi

excluePattern="" # building an exclude command consisting of patterns. We still contain the first hit of find
if [ ! -z "$excludepattern" ]; then
    for curString in $( echo "$excludepattern" | tr -s ' ' | tr ' ' '\n' ); do
        excludePattern+=" ! -path *$( echo "$curString" | tr -d ' ' )* "
    done
fi
if [ "$loglevel" -gt 1 ]; then
    echo "\$excluePattern: $excludePattern"
fi

str_inputFileList=""
if [ "$indir" ]; then
    for curPath in $( echo "${indir}" | tr -s ' ' | tr ' ' '\n' ); do
    if [ `uname -s` == "Darwin" ]; then
        curList=$( find $curPath -iname *.exe -or -iname *.dll | tr '\n' ' '  )
        else curList=$( find $curPath -iregex '.*\(dll\|exe\)' | tr '\n' ' ' )
    fi
        str_inputFileList+=" $curList"
    done
fi
if [ "$infile" ]; then
    for curFile in $( echo "${infile}" | tr -s ' ' | tr ' ' '\n' ); do
    if [ `uname -s` == "Darwin" ]; then
        curString=$( find $curPath -iname *.exe -or -iname *.dll | tr '\n' ' '  )
        else curString=$( find $curPath -iregex '.*\(dll\|exe\)' | tr '\n' ' ' )
    fi
        str_inputFileList+=" $curString"
    done
fi
if [ -z "$str_inputFileList" ]; then
    die 'there was no input defined. use --indir and/or --infile in your command'
fi
if [ "$loglevel" -gt 1 ]; then
        echo "str_inputFileList=$str_inputFileList"
        echo "opmode=$opmode"
fi

str_srcDirList=""
if [ "$srcdir" ]; then
    str_srcDirList+=" $srcdir"
fi
if [ "$srcdirs" ]; then
    str_srcDirList+=" $srcdirs"
fi
if [ "$recursivesrcdir" ]; then
    result="$( findAllSrcDirectories recursivesrcdir )"
    str_srcDirList+=" $result"
fi
if [ -z "$str_srcDirList" ]; then
    die 'there was no source directory defined. use --srcdirs or --srcdir or --recursivesrcdir in your command'
fi
if [ "$loglevel" -gt 1 ]; then
    #echo "infiles: filelist=$filelist"
    echo "infiles: str_inputFileList=$str_inputFileList"
    echo "          opmode: $opmode"
fi

if [ "$loglevel" -gt 1 ]; then
    echo "list for sources: str_srcDirList=${str_srcDirList}"
    echo "using OBJDUMP=$OBJDUMP in Version $( $OBJDUMP -V)"
fi

if [ "$loglevel" -gt 1 ]; then
    ## during development, I like to interrupt here to check the above output and skip the rest
    echo "starting in 5 seconds" && sleep 5
fi

# introducing a whitelist of well known DLLs
str_whiteListDlls="advapi32.dll kernel32.dll msvcrt.dll user32.dll ws2_32.dll gdi32.dll shell32.dll d3d9.dll ole32.dll winmm.dll mpr.dll opengl32.dll"

# function to append dependencies (recursively)
append_deps() {
    if [ "$loglevel" -gt 1 ]; then
        echo "\$1=$1 + \$2=$2 "
        sleep 2
    fi
    local bn="$( basename $1 )"
    if [ -e "$tmp/$bn" ]; then
        return 0
    fi
    if [ $# -eq 2 ]; then
        path="$1"
    else
        path=""
        for curPath in $( echo "${str_srcDirList}" | tr -s ' ' | tr ' ' '\n' ); do
            counter=0
            result=""
            result=$(find $curPath $excludePattern -iname "$bn" -type f | tail -n 1)
            if [ "$loglevel" -gt 1 ]; then
                echo "complete find command in append_deps(): # find $curPath $excludePattern -iname $bn -type f | tail -n 1 # "
            fi
            if [ ! -z "$result" ];then
                path="$result"
                counter=$(expr $counter + 1)
            fi
if [ $counter == 0 ]; then
        #echo "ERROR: could not find \$path for dll $bn, \$counter=$counter: searched $curPath"
        str_test="1"
else
        echo "OKAY:  found path for dll $bn = $path, \$counter=$counter: searched $curPath"
fi
            if [ "$loglevel" -gt 1 ]; then
                if [ $counter == 0 ]; then
                    echo "could not find \$path for dll $bn, \$counter=$counter: searched $curPath"
                else
                    echo "found path for dll $bn = $path, \$counter=$counter: searched $curPath"
                fi
            fi
        done
        if [ "$loglevel" -gt 1 ]; then
            echo "path for dll $bn now is $path"
            sleep 2
        fi
    fi
    echo "Processing $1" >&2
    if ! [ -e "$path" ]; then
        if [ "$loglevel" -gt 1 ]; then
            echo "path=$path| and we touch $tmp/$bn -> non existent in our src directories!"
            sleep 4
        fi
        touch "$tmp/$bn"
        return 0
    fi
    $OBJDUMP -p "$path" | grep 'DLL Name:' | cut -f3 -d' ' > "$tmp/$bn"
    echo "executing: $OBJDUMP -p "$path" | grep 'DLL Name:' | cut -f3 -d' ' > "$tmp/$bn""
    for dll in $( cat "$tmp/$bn" | tr '\n' ' ' ); do
        append_deps "$dll"
    done
    alldeps=$(printf "$alldeps\n%s" "$(cat $tmp/$bn)" | sort | uniq)
}

process_enforced_deps(){
    enforcedDirectory=$1
    if [ ! -d $enforcedDirectory ]; then
        echo "warning! \$enforcedDirectory=$enforcedDirectory is not valid"
        if [ "$loglevel" -gt 1 ]; then
            sleep 10
        fi
    fi
    # first we append the path to enforced dir to our list of source directories
    # if we would do this file recursively, we should loop to find those and append them all to the list
    str_srcDirList+=" $enforcedDirectory"
    # now we search for the dll and exe files to be included
    if [ `uname -s` == "Darwin" ]; then
        string=$( find $enforcedDirectory -maxdepth 1 -iname *.exe -or -iname *.dll | tr '\n' ' ' )
        else string=$( find $enforcedDirectory -maxdepth 1 -iregex '.*\(dll\|exe\)' | tr '\n' ' ' )
    fi
    if [ "$loglevel" -gt 1 ]; then
        echo "enforcedDirectory=$enforcedDirectory"
        echo "we found dlls and exes:$string"
        sleep 4
    fi
    # we hard copy it to DEST
    if [ `uname -s` == "Darwin" ]; then
        cp -av "${enforcedDirectory}" "$destdir"
        else cp -dpRxv "${enforcedDirectory}" "$destdir"
    fi
}

# beginning of the main function
# we start with the enforced dlls and exe
if [ ! -z "$enforcedir" ]; then
    for curFile in $( echo "${enforcedir}" | tr -s ' ' | tr ' ' '\n'); do
        echo "startig for file $curFile in enforce section"
        append_deps "$curFile" rel
        process_enforced_deps "$curFile"
    done
fi

# then we start with our indir or infile list
for file in $str_inputFileList; do
    echo "starting for file $file"
    #sleep 4
    append_deps "$file" rel
done

echo "I will now search for \$alldeps"
for debugOut in $( echo $alldeps | tr -s ' ' | tr '\n' ' '); do
    echo "debugOut: $debugOut"
done
if [ "$loglevel" -eq 1 ]; then
    echo "waiting 10 seconds until I proceed - so you can read my debugOut"
    sleep 10

    tmpStr=${str_srcDirList}
    echo "\$alldeps has ${#alldeps[@]} elements"
    echo "and \$str_srcDirList has ${#str_srcDirList} elements"
fi

str_summary="Here is the summary:"
str_summary="${str_summary} # ==== 8< ==== START ==== 8< ==== "
if [ $opmode == "copy" ]; then
    echo "copying files from \${curFolder} to \$destdir:"
elif [ $opmode == "print" ]; then
    echo "printing files:"
fi
for dll in $( echo $alldeps | tr '\n' ' ' ); do
    counter=0
    lowerDll=$( echo $dll | tr '[:upper:]' '[:lower:]' )
    if [ $lowerDll == $dll ]; then
        lowerDll=""
    fi
    for curFolder in $( echo "${str_srcDirList}" | tr -s ' ' | tr ' ' '\n'); do
        if [ "$loglevel" -gt 1 ]; then
            echo "search for dll $dll in curFolder $curFolder"
            sleep 1
        fi
        for curDll in $dll $lowerDll; do
            if [ -e "${curFolder}/${curDll}" ]; then
                counter=$( expr $counter + 1 )
                if [ $opmode == "copy" ]; then
                    if [ `uname -s` == "Darwin" ]; then
                        cp -av "${curFolder}/${curDll}" "$destdir"
                    else cp -dpRxv "${curFolder}/${curDll}" "$destdir"
                    fi

                elif [ $opmode == "print" ]; then
                    echo "found $dll in: ${curFolder}/${curDll}"
                else
                    echo "unknown opmode=$opmode"
                fi
            fi
        done
    done
    if [ $counter == 0 ]; then
        lowerDll=$( echo $dll | tr '[:upper:]' '[:lower:]' )
        str_whiteListDlls=$( echo ${str_whiteListDlls} | tr '[:upper:]' '[:lower:]' ) # make whiteListDlls lower case to ensure we find the match (case insensitive)
        if [ -z "${str_whiteListDlls/*${lowerDll}*}" ]; then
            if [ "$loglevel" -gt 1 ]; then
                echo "Info: \"$dll\" not found - but it is white-listed. That means: it is well known by Windows - do not worry too much. "
            fi
            str_summary="${str_summary} # Info: \"$dll\" not found - but it is white-listed. That means: it is well known by Windows - do not worry too much. "
        else
            if [ "$loglevel" -gt 1 ]; then
                echo "Warn: \"$dll\" NOT found. \$counter=$counter."
            fi
            str_summary="${str_summary} # Warn: \"$dll\" NOT found. \$counter=$counter."
        fi
    else
        if [ "$loglevel" -gt 1 ]; then
            echo "Good: \"$dll\" found in the list. \$counter=$counter"
        fi
        str_summary="${str_summary} # Good: \"$dll\" Found in the list. \$counter=$counter"
    fi
done
str_summary="${str_summary} # ==== 8< ==== END ==== 8< ==== "
echo "Job is done."
# print the summary now
for curLine in "$( echo "${str_summary}" | tr -s '#' | tr '#' '\n' )"; do # convert # to a linebreak - string ecomes an array that can be processed in for loop
    echo "$curLine"
done

# clean up the temp directory stored in $tmp
rm -rf "$tmp"
