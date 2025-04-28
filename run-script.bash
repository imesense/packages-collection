#!/usr/bin/env bash

# Set environment variables
export PATH=$(pwd)/bin:$PATH
export LUA_PATH="./share/lua/5.1/?.lua;./share/lua/5.1/?/init.lua;./?.lua;./?/init.lua"
export LUA_CPATH="./lib/lua/5.1/?.so;./?.so"

# Check path to script in arguments
if [ $# -eq 0 ]
then
    echo -e "\033[31mNo script is specified to run\033[0m"
    exit 1
fi

# Get path to script from arguments
scriptToRun=$1

# Run script
lua "$scriptToRun" "${@:2}"
