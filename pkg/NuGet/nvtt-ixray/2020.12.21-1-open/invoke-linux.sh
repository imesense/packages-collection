#!/usr/bin/env bash

source="https://github.com/castano/nvidia-texture-tools.git"
commit="aeddd65f81d36d8cb7b169b469ef25156666077e"
branch=""
destination="dep/castano/nvidia-texture-tools/$commit"

output="out"

root="../../../.."

source src/echo-helpers.sh
source src/patch-elf.sh

invoke_get()
{
    # Get sources
    if [ ! -d "$destination" ]
    then
        echo_green "Getting sources..."
        echo ""
        mkdir -p $destination
        git clone \
            $source \
            $destination
        echo ""
    fi
}

invoke_patch()
{
    script_root=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

    echo_green "Patching sources..."
    echo ""

    cd $destination
    git reset \
        --hard \
        $commit
    cd $root
}

invoke_build()
{
    # Configure
    echo ""
    echo_green "Configuring Debug target..."
    echo ""
    cmake \
        -S $destination \
        -B $destination/build/Debug \
        -G "Unix Makefiles" \
        -D CMAKE_BUILD_TYPE=Debug \
        -D CMAKE_INSTALL_PREFIX=$destination/build/Debug/install \
        -D BUILD_SHARED_LIBS=ON
    echo ""
    echo_green "Configuring RelWithDebInfo target..."
    echo ""
    cmake \
        -S $destination \
        -B $destination/build/Release \
        -G "Unix Makefiles" \
        -D CMAKE_BUILD_TYPE=RelWithDebInfo \
        -D CMAKE_INSTALL_PREFIX=$destination/build/Release/install \
        -D BUILD_SHARED_LIBS=ON

    # Build
    echo ""
    echo_green "Building Debug target..."
    echo ""
    cmake \
        --build $destination/build/Debug
    echo ""
    echo_green "Building RelWithDebInfo target..."
    echo ""
    cmake \
        --build $destination/build/Release

    # Install
    echo ""
    echo_green "Installing Debug target..."
    echo ""
    cmake \
        --install $destination/build/Debug
    echo ""
    echo_green "Installing RelWithDebInfo target..."
    echo ""
    cmake \
        --install $destination/build/Release
}

patch_files()
{
    fix_runpath $destination/build/Debug/install/lib/libnvcore.so
    fix_runpath $destination/build/Debug/install/lib/libnvimage.so
    fix_runpath $destination/build/Debug/install/lib/libnvmath.so
    fix_runpath $destination/build/Debug/install/lib/libnvthread.so
    fix_runpath $destination/build/Debug/install/lib/libnvtt.so
    fix_runpath $destination/build/Debug/install/lib/libsquishd.so.0.0

    fix_runpath $destination/build/Release/install/lib/libnvcore.so
    fix_runpath $destination/build/Release/install/lib/libnvimage.so
    fix_runpath $destination/build/Release/install/lib/libnvmath.so
    fix_runpath $destination/build/Release/install/lib/libnvthread.so
    fix_runpath $destination/build/Release/install/lib/libnvtt.so
    fix_runpath $destination/build/Release/install/lib/libsquish.so.0.0

    strip_symbols $destination/build/Debug/install/lib/libnvcore.so
    strip_symbols $destination/build/Debug/install/lib/libnvimage.so
    strip_symbols $destination/build/Debug/install/lib/libnvmath.so
    strip_symbols $destination/build/Debug/install/lib/libnvthread.so
    strip_symbols $destination/build/Debug/install/lib/libnvtt.so
    strip_symbols $destination/build/Debug/install/lib/libsquishd.so.0.0

    strip_symbols $destination/build/Release/install/lib/libnvcore.so
    strip_symbols $destination/build/Release/install/lib/libnvimage.so
    strip_symbols $destination/build/Release/install/lib/libnvmath.so
    strip_symbols $destination/build/Release/install/lib/libnvthread.so
    strip_symbols $destination/build/Release/install/lib/libnvtt.so
    strip_symbols $destination/build/Release/install/lib/libsquish.so.0.0
}

invoke_pack() {
    script_root=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    cd $script_root

    echo ""
    echo_green "Packing runtimes..."
    echo ""
    mono ~/nuget.exe pack nuspec/runtimes.linux-x64.nuspec -OutputDirectory $root/$output

    echo ""
    echo_green "Packing symbols..."
    echo ""
    mono ~/nuget.exe pack nuspec/symbols.linux-x64.nuspec -OutputDirectory $root/$output
}

invoke_actions()
{
    invoke_get
    invoke_patch
    invoke_build
    patch_files
    invoke_pack
}

invoke_actions
