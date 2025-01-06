#!/usr/bin/env bash

source="https://github.com/imesense/nvidia-texture-tools.git"
commit="64930f757db91c1208dbb2d29ca454096889dac0"
destination="dep/imesense/nvidia-texture-tools/$commit"

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
    cd $destination
    git reset --hard $commit

    cp LICENSE LICENSE.txt

    cd $root
}

invoke_build()
{
    cmake \
        -S $destination \
        -B $destination/build/arm64 \
        -G "Xcode" \
        -D CMAKE_INSTALL_PREFIX=$destination/build/arm64/install \
        -D CMAKE_OSX_ARCHITECTURES=arm64 \
        -D CMAKE_XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT="dwarf-with-dsym" \
        -D BUILD_SHARED_LIBS=ON

    cmake --build $destination/build/arm64 --config Debug
    cmake --build $destination/build/arm64 --config RelWithDebInfo
}

fix_runpath()
{
    script_root=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)

    cd $destination/build/arm64/src

    cd nvcore
    cd Debug
    $script_root/../../../../src/patch-mach-o.sh libnvcore.dylib
    cd ../RelWithDebInfo
    $script_root/../../../../src/patch-mach-o.sh libnvcore.dylib
    cd ../..

    cd nvimage
    cd Debug
    $script_root/../../../../src/patch-mach-o.sh libnvimage.dylib
    cd ../RelWithDebInfo
    $script_root/../../../../src/patch-mach-o.sh libnvimage.dylib
    cd ../..

    cd nvmath
    cd Debug
    $script_root/../../../../src/patch-mach-o.sh libnvmath.dylib
    cd ../RelWithDebInfo
    $script_root/../../../../src/patch-mach-o.sh libnvmath.dylib
    cd ../..

    cd nvthread
    cd Debug
    $script_root/../../../../src/patch-mach-o.sh libnvthread.dylib
    cd ../RelWithDebInfo
    $script_root/../../../../src/patch-mach-o.sh libnvthread.dylib
    cd ../..

    cd nvtt
    cd Debug
    $script_root/../../../../src/patch-mach-o.sh libnvtt.dylib
    cd ../RelWithDebInfo
    $script_root/../../../../src/patch-mach-o.sh libnvtt.dylib
    cd ../../../..

    cd $root/..
}

invoke_pack()
{
    script_root=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
    cd $script_root

    nuget pack runtimes.osx-arm64.nuspec -OutputDirectory $root/$output
    nuget pack symbols.osx-arm64.nuspec -OutputDirectory $root/$output
}

invoke_actions()
{
    invoke_get
    invoke_patch
    invoke_build
    fix_runpath
    invoke_pack
}

invoke_actions
