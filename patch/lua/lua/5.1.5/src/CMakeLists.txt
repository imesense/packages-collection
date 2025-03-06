# List of files
set(COMMON_HEADERS
    ${CMAKE_CURRENT_SOURCE_DIR}/lua.h
    ${CMAKE_CURRENT_SOURCE_DIR}/luaconf.h
)
set(CORE_HEADERS
    ${CMAKE_CURRENT_SOURCE_DIR}/lapi.h
    ${CMAKE_CURRENT_SOURCE_DIR}/lcode.h
    ${CMAKE_CURRENT_SOURCE_DIR}/ldebug.h
    ${CMAKE_CURRENT_SOURCE_DIR}/ldo.h
    ${CMAKE_CURRENT_SOURCE_DIR}/lfunc.h
    ${CMAKE_CURRENT_SOURCE_DIR}/lgc.h
    ${CMAKE_CURRENT_SOURCE_DIR}/llex.h
    ${CMAKE_CURRENT_SOURCE_DIR}/llimits.h
    ${CMAKE_CURRENT_SOURCE_DIR}/lmem.h
    ${CMAKE_CURRENT_SOURCE_DIR}/lobject.h
    ${CMAKE_CURRENT_SOURCE_DIR}/lopcodes.h
    ${CMAKE_CURRENT_SOURCE_DIR}/lparser.h
    ${CMAKE_CURRENT_SOURCE_DIR}/lstate.h
    ${CMAKE_CURRENT_SOURCE_DIR}/lstring.h
    ${CMAKE_CURRENT_SOURCE_DIR}/ltable.h
    ${CMAKE_CURRENT_SOURCE_DIR}/ltm.h
    ${CMAKE_CURRENT_SOURCE_DIR}/lundump.h
    ${CMAKE_CURRENT_SOURCE_DIR}/lvm.h
    ${CMAKE_CURRENT_SOURCE_DIR}/lzio.h
)
set(CORE_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/lapi.c
    ${CMAKE_CURRENT_SOURCE_DIR}/lcode.c
    ${CMAKE_CURRENT_SOURCE_DIR}/ldebug.c
    ${CMAKE_CURRENT_SOURCE_DIR}/ldo.c
    ${CMAKE_CURRENT_SOURCE_DIR}/ldump.c
    ${CMAKE_CURRENT_SOURCE_DIR}/lfunc.c
    ${CMAKE_CURRENT_SOURCE_DIR}/lgc.c
    ${CMAKE_CURRENT_SOURCE_DIR}/llex.c
    ${CMAKE_CURRENT_SOURCE_DIR}/lmem.c
    ${CMAKE_CURRENT_SOURCE_DIR}/lobject.c
    ${CMAKE_CURRENT_SOURCE_DIR}/lopcodes.c
    ${CMAKE_CURRENT_SOURCE_DIR}/lparser.c
    ${CMAKE_CURRENT_SOURCE_DIR}/lstate.c
    ${CMAKE_CURRENT_SOURCE_DIR}/lstring.c
    ${CMAKE_CURRENT_SOURCE_DIR}/ltable.c
    ${CMAKE_CURRENT_SOURCE_DIR}/ltm.c
    ${CMAKE_CURRENT_SOURCE_DIR}/lundump.c
    ${CMAKE_CURRENT_SOURCE_DIR}/lvm.c
    ${CMAKE_CURRENT_SOURCE_DIR}/lzio.c
)
set(LIB_HEADERS
    ${CMAKE_CURRENT_SOURCE_DIR}/lauxlib.h
    ${CMAKE_CURRENT_SOURCE_DIR}/lualib.h
)
set(LIB_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/lauxlib.c
    ${CMAKE_CURRENT_SOURCE_DIR}/lbaselib.c
    ${CMAKE_CURRENT_SOURCE_DIR}/ldblib.c
    ${CMAKE_CURRENT_SOURCE_DIR}/liolib.c
    ${CMAKE_CURRENT_SOURCE_DIR}/linit.c
    ${CMAKE_CURRENT_SOURCE_DIR}/lmathlib.c
    ${CMAKE_CURRENT_SOURCE_DIR}/loadlib.c
    ${CMAKE_CURRENT_SOURCE_DIR}/loslib.c
    ${CMAKE_CURRENT_SOURCE_DIR}/lstrlib.c
    ${CMAKE_CURRENT_SOURCE_DIR}/ltablib.c
)

# Project for Lua library
project(liblua
    LANGUAGES C
    VERSION ${LUA_RELEASE}
)

set(CMAKE_C_STANDARD 99)

configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/liblua.rc.in
    ${CMAKE_CURRENT_BINARY_DIR}/../res/liblua${LUA_VERSION}.rc
)
set(LIB_RESOURCES
    ${CMAKE_CURRENT_BINARY_DIR}/../res/liblua${LUA_VERSION}.rc
)

source_group("Common" FILES ${COMMON_HEADERS})
source_group("Core" FILES ${CORE_HEADERS})
source_group("Core" FILES ${CORE_SOURCES})
source_group("Library" FILES ${LIB_HEADERS})
source_group("Library" FILES ${LIB_SOURCES})
source_group("Resources" FILES ${LIB_RESOURCES})

add_library(${PROJECT_NAME} SHARED
    ${COMMON_HEADERS}
    ${CORE_HEADERS}
    ${CORE_SOURCES}
    ${LIB_HEADERS}
    ${LIB_SOURCES}
    ${LIB_RESOURCES}
)
add_library(Lua::Library ALIAS ${PROJECT_NAME})

set_target_properties(${PROJECT_NAME}
    PROPERTIES
        ENABLE_EXPORTS TRUE
)

target_include_directories(${PROJECT_NAME}
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/lua${LUA_VERSION}>
)
target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../etc)

target_compile_options(${PROJECT_NAME} PRIVATE ${LUA_BUILD_FLAGS})
target_compile_definitions(${PROJECT_NAME} PRIVATE ${LUA_BUILD_DEFINES})

generate_symbols(${PROJECT_NAME})

generate_manifest(
    ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/liblua.dll.manifest.in
    ${CMAKE_CURRENT_BINARY_DIR}/../res/liblua${LUA_VERSION}.dll.manifest
)
embed_manifest(${PROJECT_NAME}
    DLL
    ${CMAKE_CURRENT_BINARY_DIR}/../res/liblua${LUA_VERSION}.dll.manifest
)

if(WIN32 AND MSVC)
    target_compile_definitions(${PROJECT_NAME} PRIVATE ${LUA_BUILD_DEFINES_DYNAMIC})
    target_link_options(${PROJECT_NAME} PRIVATE ${LUA_LINK_FLAGS})

    set_target_properties(${PROJECT_NAME}
        PROPERTIES
            OUTPUT_NAME lua${LUA_VERSION}
    )
elseif(LINUX AND CMAKE_C_COMPILER_ID MATCHES "GNU|Clang")
    if(CMAKE_C_COMPILER_ID MATCHES "GNU")
        target_compile_options(${PROJECT_NAME} PRIVATE ${LUA_BUILD_FLAGS_DYNAMIC})
    endif()

    set_target_properties(${PROJECT_NAME}
        PROPERTIES
            OUTPUT_NAME lua${LUA_VERSION}
            SOVERSION ${LUA_VERSION_PATCH}
            INSTALL_RPATH "$ORIGIN"
            BUILD_WITH_INSTALL_RPATH TRUE
    )
elseif(APPLE AND CMAKE_C_COMPILER_ID MATCHES "AppleClang")
    set_target_properties(${PROJECT_NAME}
        PROPERTIES
            OUTPUT_NAME lua${LUA_VERSION}
            SOVERSION ${LUA_VERSION_PATCH}
            MACOSX_RPATH TRUE
            INSTALL_NAME_DIR "@rpath"
            INSTALL_RPATH "@loader_path;@loader_path/../lib;@loader_path/../../lib/$<CONFIG>"
            BUILD_WITH_INSTALL_RPATH TRUE
            XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT "dwarf-with-dsym"
    )
endif()

if(LINUX)
    target_link_libraries(${PROJECT_NAME} PRIVATE LibM::Library)
    target_link_libraries(${PROJECT_NAME} PRIVATE LibDl::Library)
endif()

# Project for Lua interpreter
project(lua
    LANGUAGES C
    VERSION ${LUA_RELEASE}
)

set(CMAKE_C_STANDARD 99)

configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/lua.rc.in
    ${CMAKE_CURRENT_BINARY_DIR}/../res/lua${LUA_VERSION}.rc
)

set(LUA_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/lua.c
)
set(LUA_RESOURCES
    ${CMAKE_CURRENT_BINARY_DIR}/../res/lua${LUA_VERSION}.rc
)

source_group("Interpreter" FILES ${LUA_SOURCES})
source_group("Resources" FILES ${LUA_RESOURCES})

if(LUA_ENABLE_INTERPRETER)
    add_executable(${PROJECT_NAME}
        ${COMMON_HEADERS}
        ${LIB_HEADERS}
        ${LUA_SOURCES}
        ${LUA_RESOURCES}
    )
    add_executable(Lua::Interpreter ALIAS ${PROJECT_NAME})

    target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
    target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../etc)

    target_compile_options(${PROJECT_NAME} PRIVATE ${LUA_BUILD_FLAGS})
    target_compile_definitions(${PROJECT_NAME} PRIVATE ${LUA_BUILD_DEFINES})

    add_dependencies(${PROJECT_NAME} Lua::Library)
    target_link_libraries(${PROJECT_NAME} PRIVATE Lua::Library)

    generate_symbols(Lua::Interpreter)

    generate_manifest(
        ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/lua.exe.manifest.in
        ${CMAKE_CURRENT_BINARY_DIR}/../res/lua${LUA_VERSION}.exe.manifest
    )
    embed_manifest(${PROJECT_NAME}
        EXE
        ${CMAKE_CURRENT_BINARY_DIR}/../res/lua${LUA_VERSION}.exe.manifest
    )

    if(WIN32 AND MSVC)
        target_link_options(${PROJECT_NAME} PRIVATE ${LUA_LINK_FLAGS})

        set_target_properties(${PROJECT_NAME}
            PROPERTIES
                OUTPUT_NAME lua
        )
    elseif(LINUX AND CMAKE_C_COMPILER_ID MATCHES "GNU|Clang")
        set_target_properties(${PROJECT_NAME}
            PROPERTIES
                OUTPUT_NAME lua${LUA_VERSION}
                INSTALL_RPATH "$ORIGIN:$ORIGIN/../lib:$ORIGIN/../../lib/$<CONFIG>"
                BUILD_WITH_INSTALL_RPATH TRUE
        )
    elseif(APPLE AND CMAKE_C_COMPILER_ID MATCHES "AppleClang")
        set_target_properties(${PROJECT_NAME}
            PROPERTIES
                OUTPUT_NAME lua${LUA_VERSION}
                MACOSX_RPATH TRUE
                INSTALL_NAME_DIR "@rpath"
                INSTALL_RPATH "@executable_path;@executable_path/../lib;@executable_path/../../lib/$<CONFIG>"
                BUILD_WITH_INSTALL_RPATH TRUE
                XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT "dwarf-with-dsym"
        )
    endif()

    if(LINUX)
        target_link_libraries(${PROJECT_NAME} PRIVATE Readline::Library::Readline)
        target_link_libraries(${PROJECT_NAME} PRIVATE Readline::Library::History)
    endif()
endif()

# Project for Lua compiler
project(luac
    LANGUAGES C
    VERSION ${LUA_RELEASE}
)

set(CMAKE_C_STANDARD 99)

configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/luac.rc.in
    ${CMAKE_CURRENT_BINARY_DIR}/../res/luac${LUA_VERSION}.rc
)

set(LUAC_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/luac.c
)
set(PRINT_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/print.c
)
set(LUAC_RESOURCES
    ${CMAKE_CURRENT_BINARY_DIR}/../res/luac${LUA_VERSION}.rc
)

source_group("Compiler" FILES ${LUAC_SOURCES})
source_group("Print" FILES ${PRINT_SOURCES})
source_group("Resources" FILES ${LUAC_RESOURCES})

if(LUA_ENABLE_COMPILER)
    add_executable(${PROJECT_NAME}
        ${COMMON_HEADERS}
        ${CORE_HEADERS}
        ${CORE_SOURCES}
        ${LUAC_SOURCES}
        ${PRINT_SOURCES}
        ${LUAC_RESOURCES}
    )
    add_executable(Lua::Compiler ALIAS ${PROJECT_NAME})

    target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
    target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../etc)

    target_compile_options(${PROJECT_NAME} PRIVATE ${LUA_BUILD_FLAGS})
    target_compile_definitions(${PROJECT_NAME} PRIVATE ${LUA_BUILD_DEFINES})

    add_dependencies(${PROJECT_NAME} Lua::Library)
    target_link_libraries(${PROJECT_NAME} PRIVATE Lua::Library)

    generate_symbols(${PROJECT_NAME})

    generate_manifest(
        ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/luac.exe.manifest.in
        ${CMAKE_CURRENT_BINARY_DIR}/../res/luac${LUA_VERSION}.exe.manifest
    )
    embed_manifest(${PROJECT_NAME}
        EXE
        ${CMAKE_CURRENT_BINARY_DIR}/../res/luac${LUA_VERSION}.exe.manifest
    )

    if(WIN32 AND MSVC)
        target_link_options(${PROJECT_NAME} PRIVATE ${LUA_LINK_FLAGS})

        set_target_properties(${PROJECT_NAME}
            PROPERTIES
                OUTPUT_NAME luac
        )
    elseif(LINUX AND CMAKE_C_COMPILER_ID MATCHES "GNU|Clang")
        set_target_properties(${PROJECT_NAME}
            PROPERTIES
                OUTPUT_NAME luac${LUA_VERSION}
                INSTALL_RPATH "$ORIGIN:$ORIGIN/../lib:$ORIGIN/../../lib/$<CONFIG>"
                BUILD_WITH_INSTALL_RPATH TRUE
        )
    elseif(APPLE AND CMAKE_C_COMPILER_ID MATCHES "AppleClang")
        set_target_properties(${PROJECT_NAME}
            PROPERTIES
                OUTPUT_NAME luac${LUA_VERSION}
                MACOSX_RPATH TRUE
                INSTALL_NAME_DIR "@rpath"
                INSTALL_RPATH "@executable_path;@executable_path/../lib;@executable_path/../../lib/$<CONFIG>"
                BUILD_WITH_INSTALL_RPATH TRUE
                XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT "dwarf-with-dsym"
        )
    endif()

    if(LINUX)
        target_link_libraries(${PROJECT_NAME} PRIVATE LibM::Library)
    endif()
endif()
