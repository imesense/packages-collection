#!/usr/bin/env bash

source="https://github.com/oneapi-src/oneTBB.git"
commit="8b829acc65569019edb896c5150d427f288e8aba"
branch="v2021.11.0"
destination="dep/oneapi-src/oneTBB/$branch"

root="../../../.."
output="out"

invoke_get() {
    if [ ! -d "$destination" ]; then
        mkdir -p $destination
        git clone --branch $branch --depth 1 $source $destination
    fi
}

invoke_patch() {
    cd $destination
    git reset --hard $commit
    cd $root
}

invoke_build() {
    cmake \
        -S $destination \
        -B $destination/build/Debug \
        -G "Unix Makefiles" \
        -D CMAKE_BUILD_TYPE=Debug \
        -D CMAKE_INSTALL_PREFIX=$destination/build/Debug/install \
        -D TBB_TEST=OFF
    cmake \
        -S $destination \
        -B $destination/build/Release \
        -G "Unix Makefiles" \
        -D CMAKE_BUILD_TYPE=RelWithDebInfo \
        -D CMAKE_INSTALL_PREFIX=$destination/build/Release/install \
        -D TBB_TEST=OFF

    cmake --build $destination/build/Debug
    cmake --build $destination/build/Release

    cmake --install $destination/build/Debug
    cmake --install $destination/build/Release
}

fix_runpath() {
    cd $destination/build/Debug/install/lib
    patchelf --set-rpath '$ORIGIN' libtbb_debug.so.12.11
    patchelf --set-rpath '$ORIGIN' libtbbmalloc_debug.so.2.11
    patchelf --set-rpath '$ORIGIN' libtbbmalloc_proxy_debug.so.2.11

    cd ../../../Release/install/lib
    patchelf --set-rpath '$ORIGIN' libtbb.so.12.11
    patchelf --set-rpath '$ORIGIN' libtbbmalloc.so.2.11
    patchelf --set-rpath '$ORIGIN' libtbbmalloc_proxy.so.2.11

    cd ../../../../../../../..
}

strip_symbols() {
    cd $destination/build/Debug/install/lib
    objcopy --only-keep-debug libtbb_debug.so.12.11 libtbb_debug.so.12.11.debug
    objcopy --strip-all libtbb_debug.so.12.11
    objcopy --add-gnu-debuglink=libtbb_debug.so.12.11.debug libtbb_debug.so.12.11

    objcopy --only-keep-debug libtbbmalloc_debug.so.2.11 libtbbmalloc_debug.so.2.11.debug
    objcopy --strip-all libtbbmalloc_debug.so.2.11
    objcopy --add-gnu-debuglink=libtbbmalloc_debug.so.2.11.debug libtbbmalloc_debug.so.2.11

    objcopy --only-keep-debug libtbbmalloc_proxy_debug.so.2.11 libtbbmalloc_proxy_debug.so.2.11.debug
    objcopy --strip-all libtbbmalloc_proxy_debug.so.2.11
    objcopy --add-gnu-debuglink=libtbbmalloc_proxy_debug.so.2.11.debug libtbbmalloc_proxy_debug.so.2.11

    cd ../../../Release/install/lib
    objcopy --only-keep-debug libtbb.so.12.11 libtbb.so.12.11.debug
    objcopy --strip-all libtbb.so.12.11
    objcopy --add-gnu-debuglink=libtbb.so.12.11.debug libtbb.so.12.11

    objcopy --only-keep-debug libtbbmalloc.so.2.11 libtbbmalloc.so.2.11.debug
    objcopy --strip-all libtbbmalloc.so.2.11
    objcopy --add-gnu-debuglink=libtbbmalloc.so.2.11.debug libtbbmalloc.so.2.11

    objcopy --only-keep-debug libtbbmalloc_proxy.so.2.11 libtbbmalloc_proxy.so.2.11.debug
    objcopy --strip-all libtbbmalloc_proxy.so.2.11
    objcopy --add-gnu-debuglink=libtbbmalloc_proxy.so.2.11.debug libtbbmalloc_proxy.so.2.11

    cd ../../../../../../../..
}

invoke_pack() {
    script_root=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    cd $script_root
    mono ~/nuget.exe pack runtimes.linux-x64.nuspec -OutputDirectory $root/$output
    mono ~/nuget.exe pack symbols.linux-x64.nuspec -OutputDirectory $root/$output
}

invoke_actions() {
    invoke_get
    invoke_patch
    invoke_build
    fix_runpath
    strip_symbols
    invoke_pack
}

invoke_actions
