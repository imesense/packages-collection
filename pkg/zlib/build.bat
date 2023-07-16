:: Configure project
call "%ProgramFiles%\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat"
cmake ^
    -S ../../dep/zlib ^
    -B ../../dep/zlib/build/Win32 ^
    -G "Visual Studio 17 2022" ^
    -A Win32 ^
    -T host=x64
cmake ^
    -S ../../dep/zlib ^
    -B ../../dep/zlib/build/x64 ^
    -G "Visual Studio 17 2022" ^
    -A x64 ^
    -T host=x64

:: Build library
msbuild ..\..\dep\zlib\build\Win32\zlib.sln ^
    -p:Configuration=Debug ^
    -p:Platform=Win32 ^
    -maxCpuCount ^
    -v:minimal
msbuild ..\..\dep\zlib\build\Win32\zlib.sln ^
    -p:Configuration=Release ^
    -p:Platform=Win32 ^
    -maxCpuCount ^
    -v:minimal
msbuild ..\..\dep\zlib\build\x64\zlib.sln ^
    -p:Configuration=Debug ^
    -p:Platform=x64 ^
    -maxCpuCount ^
    -v:minimal
msbuild ..\..\dep\zlib\build\x64\zlib.sln ^
    -p:Configuration=Release ^
    -p:Platform=x64 ^
    -maxCpuCount ^
    -v:minimal
