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
        -B $destination/build/arm64 \
        -G "Xcode" \
        -D CMAKE_XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT="dwarf-with-dsym" \
        -D CMAKE_INSTALL_PREFIX=$destination/build/arm64/install \
        -D BUILD_TESTING=OFF \
        -D YAML_BUILD_SHARED_LIBS=ON \
        -D YAML_CPP_BUILD_TOOLS=OFF

    cmake \
        -S $destination \
        -B $destination/build/x86_64 \
        -G "Xcode" \
        -D CMAKE_XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT="dwarf-with-dsym" \
        -D CMAKE_INSTALL_PREFIX=$destination/build/x86_64/install \
        -D CMAKE_OSX_ARCHITECTURES=x86_64 \
        -D BUILD_TESTING=OFF \
        -D YAML_BUILD_SHARED_LIBS=ON \
        -D YAML_CPP_BUILD_TOOLS=OFF

    cmake --build $destination/build/arm64 --config Debug
    cmake --build $destination/build/arm64 --config RelWithDebInfo

    cmake --build $destination/build/x86_64 --config Debug
    cmake --build $destination/build/x86_64 --config RelWithDebInfo

    cmake --install $destination/build/arm64 --config Debug
    cmake --install $destination/build/arm64 --config RelWithDebInfo

    cmake --install $destination/build/x86_64 --config Debug
    cmake --install $destination/build/x86_64 --config RelWithDebInfo
}

invoke_pack() {
    script_root=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

    cd $script_root

    nuget pack runtimes.osx-arm64.nuspec -OutputDirectory $root/$output
    nuget pack runtimes.osx-x64.nuspec -OutputDirectory $root/$output
    nuget pack symbols.osx-arm64.nuspec -OutputDirectory $root/$output
    nuget pack symbols.osx-x64.nuspec -OutputDirectory $root/$output
}

invoke_actions() {
    invoke_get
    invoke_build
    invoke_pack
}

invoke_actions
