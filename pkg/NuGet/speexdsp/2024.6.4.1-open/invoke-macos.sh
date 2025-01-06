#!/usr/bin/env bash

source="https://gitlab.xiph.org/xiph/speexdsp.git"
commit="dbd421d149a9c362ea16150694b75b63d757a521"
destination="dep/xiph/speexdsp/$commit"

root="../../../.."
output="out"

invoke_get()
{
    if [ ! -d "$destination" ]
    then
        mkdir -p $destination
        git clone $source $destination
    fi
}

invoke_patch()
{
    script_root=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)

    cd $destination
    git reset --hard $commit
    git am --3way --ignore-space-change --keep-cr $script_root/0001-Add-CMake-project.patch

    cp README README.md
    cp COPYING LICENSE.txt

    cd $root
}

invoke_build()
{
    cmake \
        -S $destination \
        -B $destination/build/x86_64 \
        -G "Xcode" \
        -D CMAKE_INSTALL_PREFIX=$destination/build/x86_64/install \
        -D CMAKE_OSX_ARCHITECTURES=x86_64 \
        -D CMAKE_XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT="dwarf-with-dsym" \
        -D BUILD_SHARED_LIBS=ON \
        -D FIXED_POINT=OFF \
        -D USE_SSE=ON \
        -D USE_NEON=OFF
    cmake \
        -S $destination \
        -B $destination/build/arm64 \
        -G "Xcode" \
        -D CMAKE_INSTALL_PREFIX=$destination/build/arm64/install \
        -D CMAKE_OSX_ARCHITECTURES=arm64 \
        -D CMAKE_XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT="dwarf-with-dsym" \
        -D BUILD_SHARED_LIBS=ON \
        -D FIXED_POINT=OFF \
        -D USE_SSE=OFF \
        -D USE_NEON=ON

    cmake --build $destination/build/x86_64 --config Debug
    cmake --build $destination/build/x86_64 --config RelWithDebInfo
    cmake --build $destination/build/arm64 --config Debug
    cmake --build $destination/build/arm64 --config RelWithDebInfo

    cmake --install $destination/build/x86_64 --config Debug
    cmake --install $destination/build/x86_64 --config RelWithDebInfo
    cmake --install $destination/build/arm64 --config Debug
    cmake --install $destination/build/arm64 --config RelWithDebInfo
}

invoke_pack()
{
    script_root=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
    cd $script_root

    nuget pack runtimes.osx-arm64.nuspec -OutputDirectory $root/$output
    nuget pack runtimes.osx-x64.nuspec -OutputDirectory $root/$output

    nuget pack symbols.osx-arm64.nuspec -OutputDirectory $root/$output
    nuget pack symbols.osx-x64.nuspec -OutputDirectory $root/$output
}

invoke_actions()
{
    invoke_get
    invoke_patch
    invoke_build
    invoke_pack
}

invoke_actions
