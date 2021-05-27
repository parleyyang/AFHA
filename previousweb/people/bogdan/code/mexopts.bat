@echo off

:: NOTE: this is actually not a proper .bat file executed by Windows. MEX
::       parses it and only understands a very reduced set of commands:
::       "set" and "rem" apparently, everything else is ignored (behaves as
::       "rem"), so don't do any fancy batch stuff in here. There are some
::       undocumented special vars you can set here that will trigger MEX
::       to do fancy stuff.

:: You can use MinGW64 builds (win32 threads + seh unwinding) from here:
:: http://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/

:: Tested with the following:
:: http://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/4.9.1/threads-win32/seh/x86_64-4.9.1-release-win32-seh-rt_v3-rev1.7z

:: Set this to your Mingw64 top folder, where you extracted the above
set MINGWPATH=p:\mingw64

:: Leave these alone unless you know what you're doing.
set PATH=%MINGWPATH%\bin;%PATH%
set PRELINK_CMDS=echo.>%TEMP%\mexstaticlibs

:: You can have MEX run some commands before calling the linker.
:: The two examples below will cause gcc to output the full path to some
:: static libraries so you can link statically to them (see the
:: LINGFLAGSPOST special var below). You can set any command here, however.
rem set PRELINK_CMDS1=gcc -print-file-name=libwinpthread.a >> %TEMP%\mexstaticlibs
rem set PRELINK_CMDS2=gcc -print-file-name=libquadmath.a >> %TEMP%\mexstaticlibs
rem set PRELINK_CMDS3=...

:: You can have MEX run some commands also after calling the linker
:: (e.g. upx compress the output .mex)
rem set POSTLINK_CMDS1=upx -9 "%OUTDIR%%MEX_NAME%%MEX_EXT%"
rem set POSTLINK_CMDS2=...

:: You can change these if you really need to.
set COMPILER=g++
set COMPFLAGS=-c -I"%MATLAB%\extern\include" -DMATLAB_MEX_FILE
set OPTIMFLAGS=-O3 -funroll-loops -DNDEBUG
set DEBUGFLAGS=-g
set NAME_OBJECT=-o

set LINKER=g++
set LINKFLAGS=-shared -static-libstdc++ -static-libgcc -L"%MATLAB%\bin\win64" -L"%MATLAB%\extern\lib\win64\microsoft" -lmex -lmx -leng -lmat -lmwlapack -lmwblas

set LINKFLAGSPOST=@%TEMP%\mexstaticlibs
set NAME_OUTPUT=-o "%OUTDIR%%MEX_NAME%%MEX_EXT%"


:: EXAMPLES
:: ========

:: You can compile simple files using "mex file.cpp". To support more than 2^32 elements, use
:: "mex -largeArrayDims file.cpp" ... use this by default, unless you know what you're doing.

:: To add include dirs, lib dirs, or compile/link flags, do:
:: mex COMPFLAGS="$COMPFLAGS -std=gnu99 -Ix:/include/dir" LINKFLAGS="$LINKFLAGS -Lx:/libs/dir -lmylib" -largeArrayDims file.cpp
