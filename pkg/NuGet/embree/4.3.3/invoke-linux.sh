#!/usr/bin/env bash

source="https://github.com/RenderKit/embree.git"
commit=""
branch="v4.3.3"
destination="dep/RenderKit/embree/$branch"

root="../../../.."
output="out"

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
        git clone --branch $branch --depth 1 $source $destination
    fi
}

invoke_build()
{
    Configure
    echo_green "Configuring Debug target..."
    echo ""
    cmake \
        -S $destination \
        -B $destination/build/Debug \
        -G "Unix Makefiles" \
        -D TBB_ROOT=dep/oneapi-src/oneTBB/v2021.11.0/build/Debug/install/lib/cmake/TBB \
        -D CMAKE_BUILD_TYPE=Debug \
        -D CMAKE_INSTALL_PREFIX=$destination/build/Debug/install \
        -D BUILD_SHARED_LIBS=ON \
        -D CPACK_SOURCE_7Z=OFF \
        -D CPACK_SOURCE_ZIP=OFF \
        -D EMBREE_ISA_AVX512=OFF \
        -D EMBREE_TUTORIALS=OFF \
        -D EMBREE_ZIP_MODE=OFF
    echo ""
    echo_green "Configuring RelWithDebInfo target..."
    echo ""
    cmake \
        -S $destination \
        -B $destination/build/RelWithDebInfo \
        -G "Unix Makefiles" \
        -D TBB_ROOT=dep/oneapi-src/oneTBB/v2021.11.0/build/Release/install/lib/cmake/TBB \
        -D CMAKE_BUILD_TYPE=RelWithDebInfo \
        -D CMAKE_INSTALL_PREFIX=$destination/build/RelWithDebInfo/install \
        -D BUILD_SHARED_LIBS=ON \
        -D CPACK_SOURCE_7Z=OFF \
        -D CPACK_SOURCE_ZIP=OFF \
        -D EMBREE_ISA_AVX512=OFF \
        -D EMBREE_TUTORIALS=OFF \
        -D EMBREE_ZIP_MODE=OFF

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
        --build $destination/build/RelWithDebInfo

    # Install
    echo ""
    echo_green "Installing Debug target..."
    echo ""
    cmake \
        --install $destination/build/Debug
    echo ""
    echo_green "Installing RelWithDebInfo target..."
    echo ""
    cmake --install $destination/build/RelWithDebInfo
}

patch_files()
{
    echo ""
    echo_green "Patching files..."

    fix_runpath $destination/build/Debug/install/lib/libembree4.so.4.3.3
    fix_runpath $destination/build/RelWithDebInfo/install/lib/libembree4.so.4.3.3

    strip_symbols $destination/build/Debug/install/lib/libembree4.so.4.3.3
    strip_symbols $destination/build/RelWithDebInfo/install/lib/libembree4.so.4.3.3
}

invoke_pack()
{
    script_root=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
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
    invoke_build
    patch_files
    invoke_pack
}

invoke_actions
