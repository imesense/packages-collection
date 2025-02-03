source="https://github.com/castano/nvidia-texture-tools.git"
commit="aeddd65f81d36d8cb7b169b469ef25156666077e"
destination="dep/castano/nvidia-texture-tools/$commit"

output="out"

root="../../../.."

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
    git am --3way --ignore-space-change --keep-cr $script_root/0003-Delete-hardcoded-legacy-platforms.patch
    cd ../../../..
}

invoke_build() {
    cmake \
        -S $destination \
        -B $destination/build/arm64 \
        -G "Xcode" \
        -D CMAKE_XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT="dwarf-with-dsym" \
        -D CMAKE_INSTALL_PREFIX=$destination/build/arm64/install \
        -D CMAKE_OSX_ARCHITECTURES=arm64 \
        -D BUILD_SHARED_LIBS=ON

    cd $destination/build/arm64

    xcodebuild -scheme nvtt -config Debug
    xcodebuild -scheme nvtt -config RelWithDebInfo

    cd ../../../../../..
}

fix_runpath() {
    script_root=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

    cd $destination/build/arm64/src

    cd nvcore
    cd Debug
    $script_root/../../../src/patch-mach-o.sh libnvcore.dylib
    cd ../RelWithDebInfo
    $script_root/../../../src/patch-mach-o.sh libnvcore.dylib
    cd ../..

    cd nvimage
    cd Debug
    $script_root/../../../src/patch-mach-o.sh libnvimage.dylib
    cd ../RelWithDebInfo
    $script_root/../../../src/patch-mach-o.sh libnvimage.dylib
    cd ../..

    cd nvmath
    cd Debug
    $script_root/../../../src/patch-mach-o.sh libnvmath.dylib
    cd ../RelWithDebInfo
    $script_root/../../../src/patch-mach-o.sh libnvmath.dylib
    cd ../..

    cd nvthread
    cd Debug
    $script_root/../../../src/patch-mach-o.sh libnvthread.dylib
    cd ../RelWithDebInfo
    $script_root/../../../src/patch-mach-o.sh libnvthread.dylib
    cd ../..

    cd nvtt
    cd Debug
    $script_root/../../../src/patch-mach-o.sh libnvtt.dylib
    cd ../RelWithDebInfo
    $script_root/../../../src/patch-mach-o.sh libnvtt.dylib
    cd ../..

    cd ../../../..
    cd $root
}

invoke_pack() {
    script_root=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    cd $script_root
    nuget pack runtimes.osx-arm64.nuspec -OutputDirectory $root/$output
    nuget pack symbols.osx-arm64.nuspec -OutputDirectory $root/$output
}

invoke_actions() {
    invoke_get
    invoke_patch
    invoke_build
    fix_runpath
    invoke_pack
}

invoke_actions
