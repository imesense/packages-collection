#!/usr/bin/env bash

source="https://github.com/jbeder/yaml-cpp.git"
branch="0.8.0"
destination="dep/jbeder/yaml-cpp/$branch"

root="../../../.."
output="out"

invoke_get() {
    if [ ! -d "$destination" ]; then
        mkdir -p $destination
        git clone --branch $branch --depth 1 $source $destination
        cp $destination/LICENSE $destination/LICENSE.txt
    fi
}

invoke_build() {
    cmake \
        -S $destination \
        -B $destination/build \
        -G "Ninja Multi-Config" \
        -D CMAKE_INSTALL_PREFIX=$destination/build/install \
        -D BUILD_TESTING=OFF \
        -D YAML_BUILD_SHARED_LIBS=ON \
        -D YAML_CPP_BUILD_TOOLS=OFF

    cmake --build $destination/build --config Debug
    cmake --build $destination/build --config RelWithDebInfo

    cmake --install $destination/build --config Debug
    cmake --install $destination/build --config RelWithDebInfo
}

fix_runpath() {
    cd $destination/build/Debug
    patchelf --set-rpath '$ORIGIN' libyaml-cppd.so.0.8.0

    cd ../RelWithDebInfo
    patchelf --set-rpath '$ORIGIN' libyaml-cpp.so.0.8.0

    cd ../../../../../..
}

strip_symbols() {
    cd $destination/build/Debug
    objcopy --only-keep-debug libyaml-cppd.so.0.8.0 libyaml-cppd.so.0.8.0.debug
    objcopy --strip-all libyaml-cppd.so.0.8.0
    objcopy --add-gnu-debuglink=libyaml-cppd.so.0.8.0.debug libyaml-cppd.so.0.8.0

    cd ../RelWithDebInfo
    objcopy --only-keep-debug libyaml-cpp.so.0.8.0 libyaml-cpp.so.0.8.0.debug
    objcopy --strip-all libyaml-cpp.so.0.8.0
    objcopy --add-gnu-debuglink=libyaml-cpp.so.0.8.0.debug libyaml-cpp.so.0.8.0

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
    invoke_build
    fix_runpath
    strip_symbols
    invoke_pack
}

invoke_actions
