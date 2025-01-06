#!/usr/bin/env bash

source="https://github.com/libsdl-org/SDL.git"
branch="release-2.28.5"
destination="dep/libsdl-org/SDL/$branch"

root="../../../.."
output="out"

invoke_get()
{
    if [ ! -d "$destination" ]
    then
        mkdir -p $destination
        git clone --branch $branch --depth 1 $source $destination
    fi
}

invoke_build()
{
    cmake \
        -S $destination \
        -B $destination/build/Debug \
        -D CMAKE_BUILD_TYPE=Debug \
        -G "Unix Makefiles"
    cmake \
        -S $destination \
        -B $destination/build/Release \
        -D CMAKE_BUILD_TYPE=RelWithDebInfo \
        -G "Unix Makefiles"

    cmake --build $destination/build/Debug
    cmake --build $destination/build/Release
}

strip_symbols()
{
    cd $destination/build/Debug
    objcopy --only-keep-debug libSDL2-2.0d.so.0.2800.5 libSDL2-2.0d.so.0.2800.5.debug
    objcopy --strip-all libSDL2-2.0d.so.0.2800.5
    objcopy --add-gnu-debuglink=libSDL2-2.0d.so.0.2800.5.debug libSDL2-2.0d.so.0.2800.5

    cd ../Release
    objcopy --only-keep-debug libSDL2-2.0.so.0.2800.5 libSDL2-2.0.so.0.2800.5.debug
    objcopy --strip-all libSDL2-2.0.so.0.2800.5
    objcopy --add-gnu-debuglink=libSDL2-2.0.so.0.2800.5.debug libSDL2-2.0.so.0.2800.5

    cd ../../../../../..
}

invoke_pack()
{
    script_root=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
    cd $script_root

    mono ~/nuget.exe pack runtimes.linux-x64.nuspec -OutputDirectory $root/$output
    mono ~/nuget.exe pack symbols.linux-x64.nuspec -OutputDirectory $root/$output
}

invoke_actions()
{
    invoke_get
    invoke_build
    strip_symbols
    invoke_pack
}

invoke_actions
