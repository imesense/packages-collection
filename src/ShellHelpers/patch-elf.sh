fix_runpath()
{
    local path=$1
    patchelf --set-rpath '$ORIGIN' $path
}

strip_symbols()
{
    local path=$1
    objcopy --only-keep-debug $path $path.debug
    objcopy --strip-all $path
    objcopy --add-gnu-debuglink=$path.debug $path
}
