#!/usr/bin/env bash

source="https://github.com/LuaJIT/LuaJIT.git"
commit="f0e865dd4861520258299d0f2a56491bd9d602e1"
branch=""
destination="dep/LuaJIT/LuaJIT-IXRay/$commit"

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
        git clone $source $destination
        echo ""
    fi
}

invoke_patch()
{
    script_root=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

    echo_green "Patching sources..."
    echo ""

    cp $destination/README $destination/README.md

    cd $destination
    git reset --hard $commit
    git am --3way --ignore-space-change --keep-cr $script_root/patch/0001-Fixed-LuaJit-for-Vanilla.patch
    cd $root
}

invoke_build()
{
    # Build
    echo ""
    echo_green "Building..."
    echo ""
    cd $destination
    make
    cd $root
}

patch_files()
{
    echo ""
    echo_green "Patching files..."

    fix_runpath $destination/src/libluajit.so
}

invoke_pack()
{
    script_root=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
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
    patch_files
    invoke_pack
}

invoke_actions
