:: Configure project
cmake ^
    -S ../../dep/openal-soft ^
    -B ../../dep/openal-soft/build/Win32 ^
    -G "Visual Studio 17 2022" ^
    -A Win32 ^
    -T host=x64 ^
    -DALSOFT_BUILD_ROUTER=ON ^
    -DALSOFT_REQUIRE_WINMM=ON ^
    -DALSOFT_REQUIRE_DSOUND=ON ^
    -DALSOFT_REQUIRE_WASAPI=ON ^
    -DCMAKE_INSTALL_PREFIX="../../dep/openal-soft/build/install/Win32"
cmake ^
    -S ../../dep/openal-soft ^
    -B ../../dep/openal-soft/build/x64 ^
    -G "Visual Studio 17 2022" ^
    -A x64 ^
    -T host=x64 ^
    -DALSOFT_BUILD_ROUTER=ON ^
    -DALSOFT_REQUIRE_WINMM=ON ^
    -DALSOFT_REQUIRE_DSOUND=ON ^
    -DALSOFT_REQUIRE_WASAPI=ON ^
    -DCMAKE_INSTALL_PREFIX="../../dep/openal-soft/build/install/x64"

:: Build library
call "%ProgramFiles%\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat"
msbuild ..\..\dep\openal-soft\build\Win32\OpenAL.sln ^
    -p:Configuration=Debug ^
    -p:Platform=Win32 ^
    -maxCpuCount ^
    -v:minimal ^
    -p:WindowsTargetPlatformVersion=10.0.20348.0
msbuild ..\..\dep\openal-soft\build\Win32\OpenAL.sln ^
    -p:Configuration=Release ^
    -p:Platform=Win32 ^
    -maxCpuCount ^
    -v:minimal ^
    -p:WindowsTargetPlatformVersion=10.0.20348.0
msbuild ..\..\dep\openal-soft\build\x64\OpenAL.sln ^
    -p:Configuration=Debug ^
    -p:Platform=x64 ^
    -maxCpuCount ^
    -v:minimal ^
    -p:WindowsTargetPlatformVersion=10.0.20348.0
msbuild ..\..\dep\openal-soft\build\x64\OpenAL.sln ^
    -p:Configuration=Release ^
    -p:Platform=x64 ^
    -maxCpuCount ^
    -v:minimal ^
    -p:WindowsTargetPlatformVersion=10.0.20348.0
