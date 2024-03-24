source="https://github.com/ValveSoftware/GameNetworkingSockets.git"
branch="v1.4.1"
destination="dep/ValveSoftware/GameNetworkingSockets/$branch"

name="gamenetworkingsockets"
version="1.4.1"

root="../../../.."
output="out"
objects="obj"

invoke_get() {
    if [ ! -d "$destination" ]; then
        mkdir -p $destination
        git clone $source $destination
        cp $destination/LICENSE $destination/LICENSE.txt
    fi

    if [ ! -d "$objects/$name/$version" ]; then
        mkdir -p $objects/$name/$version
        mkdir -p $objects/$name/$version/x86-64
    fi

    script_root=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    cp $script_root/vcpkg.json $objects/$name/$version/x86-64/
}

invoke_build() {
    cd $objects/$name/$version/x86-64
    vcpkg install --triplet=x64-linux-dynamic
}

strip_symbols() {
    cd vcpkg_installed/x64-linux-dynamic/debug/lib

    objcopy --only-keep-debug libcrypto.so.3 libcrypto.so.3.debug
    objcopy --strip-all libcrypto.so.3
    objcopy --add-gnu-debuglink=libcrypto.so.3.debug libcrypto.so.3

    objcopy --only-keep-debug libGameNetworkingSockets.so libGameNetworkingSockets.so.debug
    objcopy --strip-all libGameNetworkingSockets.so
    objcopy --add-gnu-debuglink=libGameNetworkingSockets.so.debug libGameNetworkingSockets.so

    objcopy --only-keep-debug libprotobufd.so.3.21.8.0 libprotobufd.so.3.21.8.0.debug
    objcopy --strip-all libprotobufd.so.3.21.8.0
    objcopy --add-gnu-debuglink=libprotobufd.so.3.21.8.0.debug libprotobufd.so.3.21.8.0

    objcopy --only-keep-debug libprotobuf-lited.so.3.21.8.0 libprotobuf-lited.so.3.21.8.0.debug
    objcopy --strip-all libprotobuf-lited.so.3.21.8.0
    objcopy --add-gnu-debuglink=libprotobuf-lited.so.3.21.8.0.debug libprotobuf-lited.so.3.21.8.0

    objcopy --only-keep-debug libprotocd.so.3.21.8.0 libprotocd.so.3.21.8.0.debug
    objcopy --strip-all libprotocd.so.3.21.8.0
    objcopy --add-gnu-debuglink=libprotocd.so.3.21.8.0.debug libprotocd.so.3.21.8.0

    objcopy --only-keep-debug libssl.so.3 libssl.so.3.debug
    objcopy --strip-all libssl.so.3
    objcopy --add-gnu-debuglink=libssl.so.3.debug libssl.so.3

    cd ../../lib

    objcopy --only-keep-debug libcrypto.so.3 libcrypto.so.3.debug
    objcopy --strip-all libcrypto.so.3
    objcopy --add-gnu-debuglink=libcrypto.so.3.debug libcrypto.so.3

    objcopy --only-keep-debug libGameNetworkingSockets.so libGameNetworkingSockets.so.debug
    objcopy --strip-all libGameNetworkingSockets.so
    objcopy --add-gnu-debuglink=libGameNetworkingSockets.so.debug libGameNetworkingSockets.so

    objcopy --only-keep-debug libprotobuf.so.3.21.8.0 libprotobuf.so.3.21.8.0.debug
    objcopy --strip-all libprotobuf.so.3.21.8.0
    objcopy --add-gnu-debuglink=libprotobuf.so.3.21.8.0.debug libprotobuf.so.3.21.8.0

    objcopy --only-keep-debug libprotobuf-lite.so.3.21.8.0 libprotobuf-lite.so.3.21.8.0.debug
    objcopy --strip-all libprotobuf-lite.so.3.21.8.0
    objcopy --add-gnu-debuglink=libprotobuf-lite.so.3.21.8.0.debug libprotobuf-lite.so.3.21.8.0

    objcopy --only-keep-debug libprotoc.so.3.21.8.0 libprotoc.so.3.21.8.0.debug
    objcopy --strip-all libprotoc.so.3.21.8.0
    objcopy --add-gnu-debuglink=libprotoc.so.3.21.8.0.debug libprotoc.so.3.21.8.0

    objcopy --only-keep-debug libssl.so.3 libssl.so.3.debug
    objcopy --strip-all libssl.so.3
    objcopy --add-gnu-debuglink=libssl.so.3.debug libssl.so.3

    cd ../../../../../../..
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
    strip_symbols
    invoke_pack
}

invoke_actions
