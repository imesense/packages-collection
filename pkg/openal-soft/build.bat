:: Configure project
call "%ProgramFiles%\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat"
cmake ^
    -S ../../dep/openal-soft ^
    -B ../../dep/openal-soft/build/Win32 ^
    -G "Visual Studio 17 2022" ^
    -A Win32 ^
    -T host=x64 ^
    -DALSOFT_REQUIRE_WINMM=ON ^
    -DALSOFT_REQUIRE_DSOUND=ON ^
    -DALSOFT_REQUIRE_WASAPI=ON
cmake ^
    -S ../../dep/openal-soft ^
    -B ../../dep/openal-soft/build/x64 ^
    -G "Visual Studio 17 2022" ^
    -A x64 ^
    -T host=x64 ^
    -DALSOFT_REQUIRE_WINMM=ON ^
    -DALSOFT_REQUIRE_DSOUND=ON ^
    -DALSOFT_REQUIRE_WASAPI=ON

:: Build library
msbuild ..\..\dep\openal-soft\build\Win32\OpenAL.sln ^
    -p:Configuration=Debug ^
    -p:Platform=Win32 ^
    -maxCpuCount ^
    -v:minimal
msbuild ..\..\dep\openal-soft\build\Win32\OpenAL.sln ^
    -p:Configuration=Release ^
    -p:Platform=Win32 ^
    -maxCpuCount ^
    -v:minimal
msbuild ..\..\dep\openal-soft\build\x64\OpenAL.sln ^
    -p:Configuration=Debug ^
    -p:Platform=x64 ^
    -maxCpuCount ^
    -v:minimal
msbuild ..\..\dep\openal-soft\build\x64\OpenAL.sln ^
    -p:Configuration=Release ^
    -p:Platform=x64 ^
    -maxCpuCount ^
    -v:minimal
