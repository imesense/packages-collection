#!/usr/bin/env bash

source="https://github.com/microsoft/mimalloc.git"
commit="8c532c32c3c96e5ba1f2283e032f69ead8add00f"
branch="v2.1.7"
destination="dep/microsoft/mimalloc/$branch"

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

invoke_patch()
{
    script_root=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)

    cd $destination
    git reset --hard $commit
    git am --3way --ignore-space-change --keep-cr $script_root/0001-Fix-incorrect-NULL-definitions.patch

    cp LICENSE LICENSE.txt

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
        -D MI_BUILD_STATIC=OFF \
        -D MI_BUILD_OBJECT=OFF \
        -D MI_BUILD_TESTS=OFF
    cmake \
        -S $destination \
        -B $destination/build/arm64 \
        -G "Xcode" \
        -D CMAKE_INSTALL_PREFIX=$destination/build/arm64/install \
        -D CMAKE_OSX_ARCHITECTURES=arm64 \
        -D CMAKE_XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT="dwarf-with-dsym" \
        -D MI_BUILD_STATIC=OFF \
        -D MI_BUILD_OBJECT=OFF \
        -D MI_BUILD_TESTS=OFF

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
