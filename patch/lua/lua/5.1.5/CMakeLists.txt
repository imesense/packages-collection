cmake_minimum_required(VERSION 3.18)

project(Lua)

option(LUA_ENABLE_INTERPRETER "Enable building Lua interpreter" OFF)
option(LUA_ENABLE_COMPILER "Enable building Lua compiler" OFF)
option(LUA_ENABLE_INSTALL "Enable install target for Lua" ON)
option(LUA_ENABLE_TESTS "Enable default tests for Lua" OFF)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/lib)

set(CMAKE_SKIP_RPATH FALSE)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)

include(GNUInstallDirs)

set(LUA_VERSION_MAJOR 5)
set(LUA_VERSION_MINOR 1)
set(LUA_VERSION_PATCH 5)
set(LUA_VERSION ${LUA_VERSION_MAJOR}.${LUA_VERSION_MINOR})
set(LUA_RELEASE ${LUA_VERSION_MAJOR}.${LUA_VERSION_MINOR}.${LUA_VERSION_PATCH})

if(WIN32 AND MSVC)
    set(LUA_BUILD_FLAGS /MP /Zi /FS)
    set(LUA_BUILD_DEFINES -D_CRT_SECURE_NO_WARNINGS)
    set(LUA_BUILD_DEFINES_DYNAMIC -DLUA_BUILD_AS_DLL)
    set(LUA_LINK_FLAGS /DEBUG)

    if(CMAKE_SYSTEM_PROCESSOR MATCHES "i386|i686|x86" OR CMAKE_VS_PLATFORM_NAME STREQUAL "Win32")
        set(LUA_BUILD_FLAGS ${LUA_BUILD_FLAGS} /arch:SSE2)
    endif()
elseif(LINUX AND CMAKE_C_COMPILER_ID MATCHES "GNU")
    set(LUA_BUILD_FLAGS -Wall -fPIC -g -Wno-misleading-indentation)
    set(LUA_BUILD_FLAGS_DYNAMIC -shared)
    set(LUA_BUILD_DEFINES -DLUA_USE_LINUX)
elseif(LINUX AND CMAKE_C_COMPILER_ID MATCHES "Clang")
    set(LUA_BUILD_FLAGS -Wall -fPIC -g -Wno-misleading-indentation -Wno-empty-body)
    set(LUA_BUILD_DEFINES -DLUA_USE_LINUX)
elseif(APPLE AND CMAKE_C_COMPILER_ID MATCHES "AppleClang")
    set(LUA_BUILD_FLAGS -Wall -fPIC -Wno-empty-body)
    set(LUA_BUILD_DEFINES -DLUA_USE_MACOSX)
endif()

if(LINUX)
    find_package(LibM REQUIRED)
    find_package(LibDl REQUIRED)
    find_package(Readline REQUIRED)
endif()

include(EmbedManifest)
include(GenerateSymbols)
add_subdirectory(src)

include(InstallLua)
add_subdirectory(test)
