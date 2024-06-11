#!/usr/bin/env bash

source="https://gitlab.xiph.org/xiph/opus.git"
commit="2554a89e02c7fc30a980b4f7e635ceae1ecba5d6"
destination="dep/xiph/opus/$commit"

root="../../../.."
output="out"

invoke_get() {
    if [ ! -d "$destination" ]; then
        mkdir -p $destination
        git clone $source $destination
    fi
}

invoke_patch() {
    cd $destination
    git reset --hard $commit
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
        -D OPUS_BUILD_SHARED_LIBRARY=ON \
        -D OPUS_X86_PRESUME_AVX2=OFF

    cmake --build $destination/build --config Debug
    cmake --build $destination/build --config RelWithDebInfo

    cmake --install $destination/build --config Debug
    cmake --install $destination/build --config RelWithDebInfo
}

fix_runpath() {
    cd $destination/build/Debug
    patchelf --set-rpath '$ORIGIN' libopus.so.0.10.1

    cd ../RelWithDebInfo
    patchelf --set-rpath '$ORIGIN' libopus.so.0.10.1

    cd ../../../../../..
}

strip_symbols() {
    cd $destination/build/Debug
    objcopy --only-keep-debug libopus.so.0.10.1 libopus.so.0.10.1.debug
    objcopy --strip-all libopus.so.0.10.1
    objcopy --add-gnu-debuglink=libopus.so.0.10.1.debug libopus.so.0.10.1

    cd ../RelWithDebInfo
    objcopy --only-keep-debug libopus.so.0.10.1 libopus.so.0.10.1.debug
    objcopy --strip-all libopus.so.0.10.1
    objcopy --add-gnu-debuglink=libopus.so.0.10.1.debug libopus.so.0.10.1

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
