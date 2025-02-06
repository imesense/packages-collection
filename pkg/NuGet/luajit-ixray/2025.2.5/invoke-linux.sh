#!/usr/bin/env bash

source="https://github.com/ixray-team/luajit-ixray.git"
commit=""
branch="d2025.2.5"
destination="dep/ixray-team/luajit-ixray/$branch"

root="../../../.."
output="out"

source src/echo-helpers.sh

invoke_get()
{
    # Get sources
    if [ ! -d "$destination" ]
    then
        echo_green "Getting sources..."
        echo ""
        mkdir -p $destination
        git clone $source $destination
        echo ""
    fi
}

invoke_patch()
{
    echo_green "Patching sources..."
    echo ""

    cp $destination/README $destination/README.md
}

invoke_build()
{
    if [ -f $destination/src/host/buildvm_arch.h ]
    then
        rm -f src/host/buildvm_arch.h
        rm -f src/jit/vmdef.lua
        rm -f src/lj_bcdef.h
        rm -f src/lj_ffdef.h
        rm -f src/lj_folddef.h
        rm -f src/lj_libdef.h
        rm -f src/lj_recdef.h
        rm -f src/lj_vm.S
    fi

    # Configure
    echo_green "Configuring Debug target..."
    echo ""
    cmake \
        -S $destination \
        -B $destination/build/Debug \
        -G "Unix Makefiles" \
        -D CMAKE_BUILD_TYPE=Debug \
        -D CMAKE_INSTALL_PREFIX=$destination/build/Debug/install
    echo ""
    echo_green "Configuring RelWithDebInfo target..."
    echo ""
    cmake \
        -S $destination \
        -B $destination/build/RelWithDebInfo \
        -G "Unix Makefiles" \
        -D CMAKE_BUILD_TYPE=RelWithDebInfo \
        -D CMAKE_INSTALL_PREFIX=$destination/build/RelWithDebInfo/install

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

invoke_pack()
{
    script_root=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
    cd $script_root

    echo ""
    echo_green "Packing runtimes..."
    echo ""
    mono ~/nuget.exe pack nuspec/runtimes.linux-x64.nuspec -OutputDirectory $root/$output
}

invoke_actions()
{
    invoke_get
    invoke_patch
    invoke_build
    invoke_pack
}

invoke_actions

