source="https://github.com/imesense/nvidia-texture-tools.git"
commit="64930f757db91c1208dbb2d29ca454096889dac0"
destination="dep/imesense/nvidia-texture-tools/$commit"

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
    cp LICENSE LICENSE.txt
    cd $root
}

invoke_build() {
    cmake \
        -S $destination \
        -B $destination/build/Debug \
        -G "Unix Makefiles" \
        -D CMAKE_BUILD_TYPE=Debug \
        -D CMAKE_INSTALL_PREFIX=$destination/build/Debug/install \
        -D BUILD_SHARED_LIBS=ON
    cmake \
        -S $destination \
        -B $destination/build/Release \
        -G "Unix Makefiles" \
        -D CMAKE_BUILD_TYPE=RelWithDebInfo \
        -D CMAKE_INSTALL_PREFIX=$destination/build/Release/install \
        -D BUILD_SHARED_LIBS=ON

    cmake --build $destination/build/Debug
    cmake --build $destination/build/Release

    cmake --install $destination/build/Debug
    cmake --install $destination/build/Release
}

fix_runpath() {
    cd $destination/build/Debug/install/lib
    patchelf --set-rpath '$ORIGIN' libnvcore.so
    patchelf --set-rpath '$ORIGIN' libnvimage.so
    patchelf --set-rpath '$ORIGIN' libnvmath.so
    patchelf --set-rpath '$ORIGIN' libnvthread.so
    patchelf --set-rpath '$ORIGIN' libnvtt.so
    patchelf --set-rpath '$ORIGIN' libsquishd.so.0.0

    cd ../../../Release/install/lib
    patchelf --set-rpath '$ORIGIN' libnvcore.so
    patchelf --set-rpath '$ORIGIN' libnvimage.so
    patchelf --set-rpath '$ORIGIN' libnvmath.so
    patchelf --set-rpath '$ORIGIN' libnvthread.so
    patchelf --set-rpath '$ORIGIN' libnvtt.so
    patchelf --set-rpath '$ORIGIN' libsquish.so.0.0

    cd ../../../../../../../..
}

strip_symbols() {
    cd $destination/build/Debug/install/lib
    objcopy --only-keep-debug libnvcore.so libnvcore.so.debug
    objcopy --strip-all libnvcore.so
    objcopy --add-gnu-debuglink=libnvcore.so.debug libnvcore.so

    objcopy --only-keep-debug libnvimage.so libnvimage.so.debug
    objcopy --strip-all libnvimage.so
    objcopy --add-gnu-debuglink=libnvimage.so.debug libnvimage.so

    objcopy --only-keep-debug libnvmath.so libnvmath.so.debug
    objcopy --strip-all libnvmath.so
    objcopy --add-gnu-debuglink=libnvmath.so.debug libnvmath.so

    objcopy --only-keep-debug libnvthread.so libnvthread.so.debug
    objcopy --strip-all libnvthread.so
    objcopy --add-gnu-debuglink=libnvthread.so.debug libnvthread.so

    objcopy --only-keep-debug libnvtt.so libnvtt.so.debug
    objcopy --strip-all libnvtt.so
    objcopy --add-gnu-debuglink=libnvtt.so.debug libnvtt.so

    objcopy --only-keep-debug libsquishd.so.0.0 libsquishd.so.0.0.debug
    objcopy --strip-all libsquishd.so.0.0
    objcopy --add-gnu-debuglink=libsquishd.so.0.0.debug libsquishd.so.0.0

    cd ../../../Release/install/lib
    objcopy --only-keep-debug libnvcore.so libnvcore.so.debug
    objcopy --strip-all libnvcore.so
    objcopy --add-gnu-debuglink=libnvcore.so.debug libnvcore.so

    objcopy --only-keep-debug libnvimage.so libnvimage.so.debug
    objcopy --strip-all libnvimage.so
    objcopy --add-gnu-debuglink=libnvimage.so.debug libnvimage.so

    objcopy --only-keep-debug libnvmath.so libnvmath.so.debug
    objcopy --strip-all libnvmath.so
    objcopy --add-gnu-debuglink=libnvmath.so.debug libnvmath.so

    objcopy --only-keep-debug libnvthread.so libnvthread.so.debug
    objcopy --strip-all libnvthread.so
    objcopy --add-gnu-debuglink=libnvthread.so.debug libnvthread.so

    objcopy --only-keep-debug libnvtt.so libnvtt.so.debug
    objcopy --strip-all libnvtt.so
    objcopy --add-gnu-debuglink=libnvtt.so.debug libnvtt.so

    objcopy --only-keep-debug libsquish.so.0.0 libsquish.so.0.0.debug
    objcopy --strip-all libsquish.so.0.0
    objcopy --add-gnu-debuglink=libsquish.so.0.0.debug libsquish.so.0.0

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
