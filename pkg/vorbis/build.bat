:: Build library
call "%ProgramFiles%\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat"
nuget restore ..\..\dep\vorbis\win32\VS2010\vorbis_dynamic.sln
msbuild ..\..\dep\vorbis\win32\VS2010\vorbis_dynamic.sln ^
    -p:Configuration=Debug ^
    -p:Platform=Win32 ^
    -maxCpuCount ^
    -nologo
msbuild ..\..\dep\vorbis\win32\VS2010\vorbis_dynamic.sln ^
    -p:Configuration=Release ^
    -p:Platform=Win32 ^
    -maxCpuCount ^
    -nologo
msbuild ..\..\dep\vorbis\win32\VS2010\vorbis_dynamic.sln ^
    -p:Configuration=Debug ^
    -p:Platform=x64 ^
    -maxCpuCount ^
    -nologo
msbuild ..\..\dep\vorbis\win32\VS2010\vorbis_dynamic.sln ^
    -p:Configuration=Release ^
    -p:Platform=x64 ^
    -maxCpuCount ^
    -nologo
