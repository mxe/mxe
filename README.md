###[MXE](http://mxe.cc) with experimental [mingw-w64](http://mingw-w64.sourceforge.net/) support (32 & 64-bit)

####Status
Tracking [mxe/master](https://github.com/mxe/mxe) packages with mingw-w64 2.07 and downgraded gcc (to 4.7)

####Getting started
```
git clone -b multi-rebase git://github.com/tonytheodore/mxe.git mxe-w64
cd mxe-w64
make check-requirements
```

This is just a quick sanity check of your system and also creates a `settings.mk` file. Change the MXE_TARGETS variable in that file and run:

```
make gcc JOBS=[num cores]
#or a list of packages required for your project, dependencies will be built automatiaclly
make qt pkg-x pkg-y JOBS=[num cores] -j[num cores/2]
```

Targets can also be specified on the command line:

`make MXE_TARGETS=x86_64-w64-mingw32 JOBS=[num cores] gcc`

`make MXE_TARGETS='x86_64-w64-mingw32 i686-w64-mingw32 i686-pc-mingw32' JOBS=[num cores] gcc`

That will take some time, so review `index.html` while it runs - usage is the same as for mxe, just replace instances of i686-pc-mingw32 as appropriate.
