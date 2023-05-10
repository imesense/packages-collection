:: Get sources
git clone --branch v1.3.5 --depth 1 https://gitlab.xiph.org/xiph/ogg.git ../../dep/ogg/v1.3.5
git clone --branch v1.1.1 --depth 1 https://gitlab.xiph.org/xiph/theora.git ../../dep/theora/v1.1.1
cd ..\..\dep\theora\v1.1.1
git reset --hard 7ffd8b2ecfc2d93ae5e16028e7528e609266bfbf
git am --3way --ignore-space-change --keep-cr < %~dp0\0001-Upgrade-libtheora_dynamic-solution-to-Visual-Studio-.patch
git am --3way --ignore-space-change --keep-cr < %~dp0\0002-Add-libogg-reference-from-NuGet.patch
git am --3way --ignore-space-change --keep-cr < %~dp0\0003-Add-libvorbis-reference-from-NuGet.patch
git am --3way --ignore-space-change --keep-cr < %~dp0\0004-Delete-rint-function-from-encoder.patch
rename README README.md
cd %~dp0

:: Build library
call "%ProgramFiles%\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat"
nuget restore ..\..\dep\theora\v1.1.1\win32\VS2008\libtheora_dynamic.sln
msbuild ..\..\dep\theora\v1.1.1\win32\VS2008\libtheora_dynamic.sln -p:Configuration=Debug -p:Platform=Win32 -maxCpuCount -nologo
msbuild ..\..\dep\theora\v1.1.1\win32\VS2008\libtheora_dynamic.sln -p:Configuration=Debug -p:Platform=x64 -maxCpuCount -nologo
msbuild ..\..\dep\theora\v1.1.1\win32\VS2008\libtheora_dynamic.sln -p:Configuration=Release -p:Platform=Win32 -maxCpuCount -nologo
msbuild ..\..\dep\theora\v1.1.1\win32\VS2008\libtheora_dynamic.sln -p:Configuration=Release -p:Platform=x64 -maxCpuCount -nologo

:: Pack library
nuget pack %~dp0\ImeSense.Packages.LibTheora.1.1.1.nuspec -OutputDirectory ..
