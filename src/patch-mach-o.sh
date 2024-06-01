#!/usr/bin/env bash

binary_file="$1"

current_id=$(otool -l "$1" | grep -A2 LC_ID_DYLIB | grep name)
if [ -n "$current_id" ]; then
    install_name_tool -delete_id "$1"
    echo "Deleted existing LC_ID_DYLIB record: $current_id in $1"
fi

install_name_tool -add_rpath @loader_path "$1"
echo "Added new RPATH record: @loader_path in $1"

dependencies=$(otool -L "$1" | grep -vE '^\s*(\/usr\/lib|\/System)')
for dependency in $dependencies; do
    install_name_tool -change "$dependency" "@rpath/$(basename "$dependency")" "$1"
    echo "Replaced LC_LOAD_DYLIB record: $dependency in $1"
done

install_name_tool -id "@rpath/$1" "$1"
echo "Added new LC_ID_DYLIB record: @rpath/$1 in $1"
