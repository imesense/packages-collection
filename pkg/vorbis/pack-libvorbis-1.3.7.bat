:: Get sources
git clone --branch v1.3.5 --depth 1 https://gitlab.xiph.org/xiph/ogg.git ../../dep/ogg/v1.3.5
git clone --branch v1.3.7 --depth 1 https://gitlab.xiph.org/xiph/vorbis.git ../../dep/vorbis/v1.3.7
cd ..\..\dep\vorbis\v1.3.7
git reset --hard 0657aee69dec8508a0011f47f3b69d7538e9d262
git am --3way --ignore-space-change --keep-cr < %~dp0\0001-Upgrade-vorbis_dynamic-solution-to-Visual-Studio-202.patch
git am --3way --ignore-space-change --keep-cr < %~dp0\0002-Add-libogg-reference-from-NuGet.patch
cd %~dp0

:: Build library
call "%ProgramFiles%\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat"
nuget restore ..\..\dep\vorbis\v1.3.7\win32\VS2010\vorbis_dynamic.sln
msbuild ..\..\dep\vorbis\v1.3.7\win32\VS2010\vorbis_dynamic.sln -p:Configuration=Debug -p:Platform=Win32 -maxCpuCount -nologo
msbuild ..\..\dep\vorbis\v1.3.7\win32\VS2010\vorbis_dynamic.sln -p:Configuration=Debug -p:Platform=x64 -maxCpuCount -nologo
msbuild ..\..\dep\vorbis\v1.3.7\win32\VS2010\vorbis_dynamic.sln -p:Configuration=Release -p:Platform=Win32 -maxCpuCount -nologo
msbuild ..\..\dep\vorbis\v1.3.7\win32\VS2010\vorbis_dynamic.sln -p:Configuration=Release -p:Platform=x64 -maxCpuCount -nologo

:: Pack library
nuget pack %~dp0\ImeSense.Packages.LibVorbis.1.3.7.nuspec -OutputDirectory ..
