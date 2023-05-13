:: Build library
call "%ProgramFiles%\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat"
msbuild ..\..\dep\ogg\win32\VS2015\libogg.sln -p:Configuration=DebugDLL -p:Platform=Win32 -maxCpuCount -nologo
msbuild ..\..\dep\ogg\win32\VS2015\libogg.sln -p:Configuration=DebugDLL -p:Platform=x64 -maxCpuCount -nologo
msbuild ..\..\dep\ogg\win32\VS2015\libogg.sln -p:Configuration=ReleaseDLL -p:Platform=Win32 -maxCpuCount -nologo
msbuild ..\..\dep\ogg\win32\VS2015\libogg.sln -p:Configuration=ReleaseDLL -p:Platform=x64 -maxCpuCount -nologo
