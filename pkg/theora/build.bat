:: Build library
call "%ProgramFiles%\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat"
nuget restore ..\..\dep\theora\win32\VS2008\libtheora_dynamic.sln
msbuild ..\..\dep\theora\win32\VS2008\libtheora_dynamic.sln -p:Configuration=Debug -p:Platform=Win32 -maxCpuCount -nologo
msbuild ..\..\dep\theora\win32\VS2008\libtheora_dynamic.sln -p:Configuration=Debug -p:Platform=x64 -maxCpuCount -nologo
msbuild ..\..\dep\theora\win32\VS2008\libtheora_dynamic.sln -p:Configuration=Release -p:Platform=Win32 -maxCpuCount -nologo
msbuild ..\..\dep\theora\win32\VS2008\libtheora_dynamic.sln -p:Configuration=Release -p:Platform=x64 -maxCpuCount -nologo
