#!/bin/bash
#

# print version and license
# is hereby part of the code and also displayed to the user 
version() {
	cat <<EOF >&2

Welcome to $( basename $0)!
Authors:  Lars Holger Engelhard - DL5RCW (2016)
          Tiancheng "Timothy" Gu (2014)

Version: 1.0

# This file is part of the MXE Project, sponsored by the named authors
# it supports the shared build approach by providing an easy way to
# check for library dependencies in a recursive manner

# Copyright (c) 2014 Tiancheng "Timothy" Gu
#           (c) 2016 Lars Holger Engelhard - DL5RCW

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
tmp=`mktemp -d`

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
  -d, --destdir           Destination directory
  -f, --infile            The input executable file or DLL.
  -F, --infiles, --indir  The input directory of executable files and/or DLLs.
  -s, --srcdir            [ multiCall ] The directory with DLLs that can be copied. 
  -S, --srcdirs           [ multiCall ] List of directories with DLLs that can be copied. Put "" around them, e.g. "/dir1 /root/dir2 /root/dir3" 
  -R, --recursivesrcdir   [ multiCall ] Target directory for recursive search of folders containing *dll files  
 
Optional binary settings:
  -o, --objdump           Specify the path or name of your objdump application
  -e, --enforce           Enforce executable files and/or DLLs of a specific directory 
                          It will be entirely copied - flat, non recursive. assumes *.dll and *.exe in the top level directory
                          e.g. <path_to_mxe>/mxe/usr/<compiler>/qt5/plugins/platforms/ - for qwindows.dll becomes
                          DESTDIR/platforms/ containing qwindows.dll
Other options:
  -h,-H, --help           Display this message and exit
  -v,-V, --version        Display version of this application
  -l,-L, --logLevel       Display more output - default is 1

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
	for element in $(find $curPath -name "*.dll"); do
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
		infile="$1"
		shift
		;;
	-F|--indir|--infiles)
		indir="$1"
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
	-o|--objdump)
		OBJDUMP="$1"
		shift
		;;
	-e|--enforce)
		enforce+=" $1"
		shift
		;;
	-l|-L|--logLevel)
		logLevel="$1"
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
if ! [ "$logLevel" ]; then
	logLevel=0
fi

if ! [ "$opmode" ]; then 
	opmode="copy"  	# used as default in productive
	#opmode="print" 	# used as default in development
fi

if [ "$indir" ] && [ "$infile" ]; then
	die '--indir and --infile are mutually exclusive.'
elif ! [ "$indir" ] && ! [ "$infile" ]; then
	die 'Neither --indir nor --infile is specified.'
fi

if ! [ "$destdir" ]; then
	die '--destdir is not specified.'
fi
if ! ([ "$srcdir"  ] || [ "$srcdirs" ] || [ "$recursivesrcdir" ]); then
	die 'either --srcdir or --srcdirs or --recursivesrcdir must be specified.'
fi

if [ "$indir" ]; then
    filelist=`find $indir -iregex '.*\(dll\|exe\)' | tr '\n' ' '`
else
    filelist="$infile"
fi

if [ -n "$(ls -A $destdir 2>/dev/null)" ]; then
    echo 'Warning: --destdir already exists and contains files.' >&2
else
    mkdir -p "$destdir"
    echo "info: created --destdir $destdir"
fi

if [ "$logLevel" -gt 1 ]; then
	echo "filelist=$filelist"
	echo "opmode=$opmode"
fi

ar_srcDirList=()
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
if [ "$logLevel" -gt 1 ]; then
	echo "infiles: filelist=$filelist"
	echo "          opmode: $opmode"
fi

if [ "$logLevel" -gt 1 ]; then
	echo "list for sources: str_srcDirList=${str_srcDirList}"
	echo "using OBJDUMP=$OBJDUMP in Version $( $OBJDUMP -V)"
fi

if [ "$logLevel" -gt 1 ]; then
	## during development, I like to interrupt here to check the above output and skip the rest
	echo "starting in 5 seconds" && sleep 5
fi

# function to append dependencies (recursively)
append_deps() {
	if [ "$logLevel" -gt 1 ]; then
		echo "\$1=$1 + \$2=$2 "
		sleep 2
	fi
	local bn="`basename $1`"
	if [ -e "$tmp/$bn" ]; then
		return 0
	fi
	if [ $# -eq 2 ]; then
		path="$1"
	else
		path=""
		for curPath in $( echo "${str_srcDirList}" | tr -s ' ' | tr ' ' '\n' ); do
			counter=0
			result=$(find $curPath -name "$bn" | tail -n 1)
			if [ ! -z $result ];then
				path=$result
				counter=$(expr $counter + 1)
			fi
			if [ "$logLevel" -gt 1 ]; then
				if [ $counter == 0 ]; then
					echo "could not find \$path for dll $bn, \$counter=$counter: searched $curPath"
				else
					echo "found path for dll $bn = $path, \$counter=$counter: searched $curPath"
				fi
			fi
		done
		if [ "$logLevel" -gt 1 ]; then
			echo "path for dll $bn now is $path"
			sleep 2
		fi
	fi
	echo "Processing $1" >&2
	if ! [ -e "$path" ]; then
		if [ "$logLevel" -gt 1 ]; then
			echo "path=$path| and we touch $tmp/$bn -> non existent in our src directories!"
			sleep 4
		fi
		touch "$tmp/$bn"
		return 0
	fi
	$OBJDUMP -p "$path" | grep 'DLL Name:' | cut -f3 -d' ' > "$tmp/$bn"
	echo "executing: $OBJDUMP -p "$path" | grep 'DLL Name:' | cut -f3 -d' ' > "$tmp/$bn""
	for dll in `cat "$tmp/$bn" | tr '\n' ' '`; do
		append_deps "$dll"
	done
	alldeps=$(printf "$alldeps\n%s" "$(cat $tmp/$bn)" | sort | uniq)
}

process_enforced_deps(){
	enforcedDirectory=$1
	if [ ! -d $enforcedDirectory ]; then
		echo "warning! \$enforcedDirectory=$enforcedDirectory is not valid"
		if [ "$logLevel" -gt 1 ]; then
			sleep 10
		fi
	fi
	# first we append the path to enforced dir to our list of source directories
	# if we would do this file recursively, we should loop to find those and append them all to the list
	str_srcDirList+=" $enforcedDirectory"
	# now we search for the dll and exe files to be included
	string=$( find $enforcedDirectory -maxdepth 1 -iregex '.*\(dll\|exe\)' | tr '\n' ' ' )
	if [ "$logLevel" -gt 1 ]; then
		echo "enforcedDirectory=$enforcedDirectory"
		echo "we found dlls and exes:$string"
		sleep 4
	fi
	# we hard copy it to DEST
	cp -dpRxv "${enforcedDirectory}" "$destdir"
}

# beginning of the main function
# we start with the enforced dlls and exe
if [ ! -z $enforce ]; then
	for curFile in $enforce; do
		echo "startig for file $curFile"
		append_deps "$curFile" rel
		process_enforced_deps "$curFile" 
	done
fi

# then we start with our indir or infile list
for file in $filelist; do
	echo "starting for file $file"
	#sleep 4
	append_deps "$file" rel
done

echo "I will now search for \$alldeps"
for debugOut in $( echo $alldeps | tr -s ' ' | tr '\n' ' '); do
	echo "debugOut: $debugOut"
done
if [ "$logLevel" -eq 1 ]; then
	echo "waiting 10 seconds until I proceed - so you can read my debugOut"
	sleep 10

	tmpStr=${str_srcDirList}
	echo "\$alldeps has ${#alldeps[@]} elements"
	echo "and \$str_srcDirList has ${#str_srcDirList} elements"
	echo "waiting another 10 seconds"
	#sleep 10
fi

for dll in `echo $alldeps | tr '\n' ' '`; do
	counter=0
	lower_dll=`echo $dll | tr '[:upper:]' '[:lower:]'`
	if [ $lower_dll == $dll ]; then
		lower_dll=""
	fi
	for curFolder in $( echo "${str_srcDirList}" | tr -s ' ' | tr ' ' '\n'); do
		if [ "$logLevel" -gt 1 ]; then
			echo "search for dll $dll in curFolder $curFolder"
			sleep 1
		fi
		for the_dll in $dll $lower_dll; do
			if [ -e "${curFolder}/${the_dll}" ]; then
				counter=$(expr $counter + 1)
				if [ $opmode == "copy" ]; then
					cp -dpRxv "${curFolder}/${the_dll}" "$destdir"
				elif [ $opmode == "print" ]; then
					echo "found $dll in: ${curFolder}/${the_dll}"
				else
					echo "unknown opmode=$opmode"
				fi
			fi
		done
	done
	if [ $counter == 0 ]; then
		echo "Warning: \"$dll\"  not found. \$counter=$counter." >&2
	else
		echo "Found dll $dll in the list. \$counter=$counter" >&2
	fi
done

rm -rf "$tmp"
