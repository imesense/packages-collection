:: Configure project
call "%ProgramFiles%\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat"
cmake ^
    -S ../../dep/DiligentEngine ^
    -B ../../dep/DiligentEngine/build/Win32 ^
    -G "Visual Studio 17 2022" ^
    -A Win32 ^
    -T host=x64 ^
    -D CMAKE_INSTALL_PREFIX=../../dep/DiligentEngine/build/Win32/install ^
    -D DILIGENT_BUILD_FX=FALSE ^
    -D DILIGENT_BUILD_TOOLS=TRUE ^
    -D DILIGENT_BUILD_SAMPLES=TRUE ^
    -D DILIGENT_IMPROVE_SPIRV_TOOLS_DEBUG_PERF=TRUE ^
    -D DILIGENT_INSTALL_CORE=TRUE ^
    -D DILIGENT_INSTALL_PDB=TRUE ^
    -D DILIGENT_INSTALL_TOOLS=TRUE ^
    -D DILIGENT_NO_FORMAT_VALIDATION=TRUE ^
    -D DILIGENT_NO_METAL=TRUE
cmake ^
    -S ../../dep/DiligentEngine ^
    -B ../../dep/DiligentEngine/build/x64 ^
    -G "Visual Studio 17 2022" ^
    -A x64 ^
    -T host=x64 ^
    -D CMAKE_INSTALL_PREFIX=../../dep/DiligentEngine/build/x64/install ^
    -D DILIGENT_BUILD_FX=FALSE ^
    -D DILIGENT_BUILD_TOOLS=TRUE ^
    -D DILIGENT_BUILD_SAMPLES=TRUE ^
    -D DILIGENT_IMPROVE_SPIRV_TOOLS_DEBUG_PERF=TRUE ^
    -D DILIGENT_INSTALL_CORE=TRUE ^
    -D DILIGENT_INSTALL_PDB=TRUE ^
    -D DILIGENT_INSTALL_TOOLS=TRUE ^
    -D DILIGENT_NO_FORMAT_VALIDATION=TRUE ^
    -D DILIGENT_NO_METAL=TRUE

:: Build library
msbuild ..\..\dep\DiligentEngine\build\Win32\DiligentEngine.sln ^
    -p:Configuration=Debug ^
    -p:Platform=Win32 ^
    -maxCpuCount ^
    -v:minimal
msbuild ..\..\dep\DiligentEngine\build\Win32\DiligentEngine.sln ^
    -p:Configuration=Release ^
    -p:Platform=Win32 ^
    -maxCpuCount ^
    -v:minimal
msbuild ..\..\dep\DiligentEngine\build\x64\DiligentEngine.sln ^
    -p:Configuration=Debug ^
    -p:Platform=x64 ^
    -maxCpuCount ^
    -v:minimal
msbuild ..\..\dep\DiligentEngine\build\x64\DiligentEngine.sln ^
    -p:Configuration=Release ^
    -p:Platform=x64 ^
    -maxCpuCount ^
    -v:minimal

:: Prepare files
cmake ^
    --install ../../dep/DiligentEngine/build/Win32 ^
    --config Debug
cmake ^
    --install ../../dep/DiligentEngine/build/Win32
cmake ^
    --install ../../dep/DiligentEngine/build/x64 ^
    --config Debug
cmake ^
    --install ../../dep/DiligentEngine/build/x64
