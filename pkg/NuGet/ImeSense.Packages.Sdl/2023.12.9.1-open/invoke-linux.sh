source="https://github.com/libsdl-org/SDL.git"
commit="f3d8a2def5e2214290bbbc075a6381fa9b753acf"
destination="dep/libsdl-org/SDL/$commit"

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
    cd $root
}

invoke_build() {
    cmake \
        -S $destination \
        -B $destination/build/Debug \
        -D CMAKE_BUILD_TYPE=Debug \
        -G "Unix Makefiles"
    cmake \
        -S $destination \
        -B $destination/build/Release \
        -D CMAKE_BUILD_TYPE=RelWithDebInfo \
        -G "Unix Makefiles"

    cmake --build $destination/build/Debug
    cmake --build $destination/build/Release
}

strip_symbols() {
    cd $destination/build/Debug
    objcopy --only-keep-debug libSDL3.so.0.0.0 libSDL3.so.0.0.0.debug
    objcopy --strip-all libSDL3.so.0.0.0
    objcopy --add-gnu-debuglink=libSDL3.so.0.0.0.debug libSDL3.so.0.0.0

    cd ../Release
    objcopy --only-keep-debug libSDL3.so.0.0.0 libSDL3.so.0.0.0.debug
    objcopy --strip-all libSDL3.so.0.0.0
    objcopy --add-gnu-debuglink=libSDL3.so.0.0.0.debug libSDL3.so.0.0.0

    cd ../../../../../..
}

invoke_pack() {
    script_root=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    cd $script_root
    mono ~/nuget.exe pack ImeSense.Packages.Sdl.Runtimes.linux-x64.nuspec -OutputDirectory $root/$output
    mono ~/nuget.exe pack ImeSense.Packages.Sdl.Symbols.linux-x64.nuspec -OutputDirectory $root/$output
}

invoke_actions() {
    invoke_get
    invoke_patch
    invoke_build
    strip_symbols
    invoke_pack
}

invoke_actions
