#!/usr/bin/env bash

source="https://gitlab.xiph.org/xiph/speexdsp.git"
commit="dbd421d149a9c362ea16150694b75b63d757a521"
destination="dep/xiph/speexdsp/$commit"

root="../../../.."
output="out"

invoke_get() {
    if [ ! -d "$destination" ]; then
        mkdir -p $destination
        git clone $source $destination
    fi
}

invoke_patch() {
    script_root=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

    cd $destination
    git reset --hard $commit
    git am --3way --ignore-space-change --keep-cr $script_root/0001-Add-CMake-project.patch
    cp README README.md
    cp COPYING LICENSE.txt
    cd $root
}

invoke_build() {
    cmake \
        -S $destination \
        -B $destination/build \
        -G "Ninja Multi-Config" \
        -D CMAKE_INSTALL_PREFIX=$destination/build/install \
        -D BUILD_SHARED_LIBS=ON \
        -D FIXED_POINT=OFF \
        -D USE_SSE=ON \
        -D USE_NEON=OFF

    cmake --build $destination/build --config Debug
    cmake --build $destination/build --config RelWithDebInfo

    cmake --install $destination/build --config Debug
    cmake --install $destination/build --config RelWithDebInfo
}

fix_runpath() {
    cd $destination/build/Debug
    patchelf --set-rpath '$ORIGIN' libspeexdsp.so.1.2.0

    cd ../RelWithDebInfo
    patchelf --set-rpath '$ORIGIN' libspeexdsp.so.1.2.0

    cd ../../../../../..
}

strip_symbols() {
    cd $destination/build/Debug
    objcopy --only-keep-debug libspeexdsp.so.1.2.0 libspeexdsp.so.1.2.0.debug
    objcopy --strip-all libspeexdsp.so.1.2.0
    objcopy --add-gnu-debuglink=libspeexdsp.so.1.2.0.debug libspeexdsp.so.1.2.0

    cd ../RelWithDebInfo
    objcopy --only-keep-debug libspeexdsp.so.1.2.0 libspeexdsp.so.1.2.0.debug
    objcopy --strip-all libspeexdsp.so.1.2.0
    objcopy --add-gnu-debuglink=libspeexdsp.so.1.2.0.debug libspeexdsp.so.1.2.0

    cd ../../../../../..
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
