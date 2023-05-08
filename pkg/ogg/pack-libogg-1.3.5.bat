:: Get sources
git clone --branch v1.3.5 --depth 1 https://gitlab.xiph.org/xiph/ogg.git ../../dep/ogg/v1.3.5
cd ..\..\dep\ogg\v1.3.5
git reset --hard e1774cd77f471443541596e09078e78fdc342e4f
git am --3way --ignore-space-change --keep-cr < %~dp0\0001-Upgrade-libogg-solution-to-Visual-Studio-2022.patch
cd %~dp0

:: Build library
call "%ProgramFiles%\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat"
msbuild ..\..\dep\ogg\v1.3.5\win32\VS2015\libogg.sln -p:Configuration=DebugDLL -p:Platform=Win32 -maxCpuCount -nologo
msbuild ..\..\dep\ogg\v1.3.5\win32\VS2015\libogg.sln -p:Configuration=DebugDLL -p:Platform=x64 -maxCpuCount -nologo
msbuild ..\..\dep\ogg\v1.3.5\win32\VS2015\libogg.sln -p:Configuration=ReleaseDLL -p:Platform=Win32 -maxCpuCount -nologo
msbuild ..\..\dep\ogg\v1.3.5\win32\VS2015\libogg.sln -p:Configuration=ReleaseDLL -p:Platform=x64 -maxCpuCount -nologo

:: Pack library
nuget pack %~dp0\ImeSense.Packages.LibOgg.1.3.5.nuspec -OutputDirectory ..
