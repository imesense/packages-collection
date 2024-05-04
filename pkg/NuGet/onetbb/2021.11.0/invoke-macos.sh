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
        -B $destination/build/x86_64 \
        -G "Xcode" \
        -DCMAKE_XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT="dwarf-with-dsym" \
        -D CMAKE_INSTALL_PREFIX=$destination/build/x86_64/install \
        -D CMAKE_OSX_ARCHITECTURES=x86_64 \
        -D CMAKE_CXX_FLAGS="-Wno-shorten-64-to-32" \
        -D TBB_TEST=OFF
    cmake \
        -S $destination \
        -B $destination/build/arm64 \
        -G "Xcode" \
        -DCMAKE_XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT="dwarf-with-dsym" \
        -D CMAKE_INSTALL_PREFIX=$destination/build/arm64/install \
        -D CMAKE_OSX_ARCHITECTURES=arm64 \
        -D CMAKE_CXX_FLAGS="-Wno-shorten-64-to-32" \
        -D TBB_TEST=OFF

    cmake --build $destination/build/x86_64 --config Debug
    cmake --build $destination/build/x86_64 --config RelWithDebInfo
    cmake --build $destination/build/arm64 --config Debug
    cmake --build $destination/build/arm64 --config RelWithDebInfo

    cmake --install $destination/build/x86_64 --config Debug
    cmake --install $destination/build/x86_64 --config RelWithDebInfo
    cmake --install $destination/build/arm64 --config Debug
    cmake --install $destination/build/arm64 --config RelWithDebInfo
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
    invoke_patch
    invoke_build
    invoke_pack
}

invoke_actions