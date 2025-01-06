#!/usr/bin/env bash

source="http://www.oberhumer.com/opensource/lzo/download/lzo-2.10.tar.gz"
branch="lzo-2.10"
destination="dep/lzo/lzo/$branch"

root="../../../.."
output="out"

invoke_get()
{
    if [ ! -d "$destination" ]
    then
        mkdir -p $destination
    fi

    if [ ! -f "$destination/../lzo-2.10.tar.gz" ]
    then
        cd $destination/..
        curl -o lzo-2.10.tar.gz $source
        tar -xf lzo-2.10.tar.gz

        cd lzo-2.10
        git init
        git add .
        git commit -m "Initial commit"

        cd $root
    fi
}

invoke_patch()
{
    script_root=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)

    cd $destination
    git reset --hard HEAD~1
    git am --3way --ignore-space-change --keep-cr $script_root/0001-Enable-exports-for-non-Windows-build.patch

    cp README README.md
    cp COPYING LICENSE.txt

    cd $root
}

invoke_build()
{
    cmake \
        -S $destination \
        -B $destination/build \
        -G "Ninja Multi-Config" \
        -D CMAKE_INSTALL_PREFIX=$destination/build/install \
        -D ENABLE_STATIC=OFF \
        -D ENABLE_SHARED=ON

    cmake --build $destination/build --config Debug
    cmake --build $destination/build --config RelWithDebInfo

    cmake --install $destination/build --config Debug
    cmake --install $destination/build --config RelWithDebInfo
}

fix_runpath()
{
    cd $destination/build/Debug
    patchelf --set-rpath '$ORIGIN' liblzo2.so.2.0.0

    cd ../RelWithDebInfo
    patchelf --set-rpath '$ORIGIN' liblzo2.so.2.0.0

    cd ../../../../../..
}

strip_symbols()
{
    cd $destination/build/Debug
    objcopy --only-keep-debug liblzo2.so.2.0.0 liblzo2.so.2.0.0.debug
    objcopy --strip-all liblzo2.so.2.0.0
    objcopy --add-gnu-debuglink=liblzo2.so.2.0.0.debug liblzo2.so.2.0.0

    cd ../RelWithDebInfo
    objcopy --only-keep-debug liblzo2.so.2.0.0 liblzo2.so.2.0.0.debug
    objcopy --strip-all liblzo2.so.2.0.0
    objcopy --add-gnu-debuglink=liblzo2.so.2.0.0.debug liblzo2.so.2.0.0

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
    invoke_patch
    invoke_build
    fix_runpath
    strip_symbols
    invoke_pack
}

invoke_actions
