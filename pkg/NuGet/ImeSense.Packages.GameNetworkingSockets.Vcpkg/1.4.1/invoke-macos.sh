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
        mkdir -p $objects/$name/$version/arm64
    fi

    script_root=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    cp $script_root/vcpkg.json $objects/$name/$version/x86-64/
    cp $script_root/vcpkg.json $objects/$name/$version/arm64/
}

invoke_build() {
    cd $objects/$name/$version/x86-64
    vcpkg install --triplet=x64-osx-dynamic
    cd ../arm64
    vcpkg install --triplet=arm64-osx-dynamic

    cd $root
}

invoke_pack() {
    script_root=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    cd $script_root
    nuget pack runtimes.osx-x64.nuspec -OutputDirectory $root/$output
    nuget pack runtimes.osx-arm64.nuspec -OutputDirectory $root/$output
}

invoke_actions() {
    invoke_get
    invoke_build
    invoke_pack
}

invoke_actions
