source="https://github.com/microsoft/mimalloc.git"
commit="8c532c32c3c96e5ba1f2283e032f69ead8add00f"
branch="v2.1.7"
destination="dep/microsoft/mimalloc/$branch"

root="../../../.."
output="out"

invoke_get() {
    if [ ! -d "$destination" ]; then
        mkdir -p $destination
        git clone --branch $branch --depth 1 $source $destination
    fi
}

invoke_patch() {
    script_root=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

    cd $destination
    git reset --hard $commit
    git am --3way --ignore-space-change --keep-cr $script_root/0001-Fix-incorrect-NULL-definitions.patch
    cp LICENSE LICENSE.txt
    cd $root
}

invoke_build() {
    cmake \
        -S $destination \
        -B $destination/build \
        -G "Ninja Multi-Config" \
        -D CMAKE_INSTALL_PREFIX=$destination/build/install \
        -D MI_BUILD_STATIC=OFF \
        -D MI_BUILD_OBJECT=OFF \
        -D MI_BUILD_TESTS=OFF

    cmake --build $destination/build --config Debug
    cmake --build $destination/build --config RelWithDebInfo

    cmake --install $destination/build --config Debug
    cmake --install $destination/build --config RelWithDebInfo
}

fix_runpath() {
    cd $destination/build/Debug
    patchelf --set-rpath '$ORIGIN' libmimalloc.so.2.1

    cd ../RelWithDebInfo
    patchelf --set-rpath '$ORIGIN' libmimalloc.so.2.1

    cd ../../../../../..
}

strip_symbols() {
    cd $destination/build/Debug
    objcopy --only-keep-debug libmimalloc.so.2.1 libmimalloc.so.2.1.debug
    objcopy --strip-all libmimalloc.so.2.1
    objcopy --add-gnu-debuglink=libmimalloc.so.2.1.debug libmimalloc.so.2.1

    cd ../RelWithDebInfo
    objcopy --only-keep-debug libmimalloc.so.2.1 libmimalloc.so.2.1.debug
    objcopy --strip-all libmimalloc.so.2.1
    objcopy --add-gnu-debuglink=libmimalloc.so.2.1.debug libmimalloc.so.2.1

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
