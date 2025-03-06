# Return if not enabled installing
if(NOT LUA_ENABLE_INSTALL)
    return()
endif()

# Install library
install(
    TARGETS liblua
    EXPORT LuaTargets
    RUNTIME
        COMPONENT Library
        DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY
        COMPONENT Library
        DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE
        COMPONENT Library
        DESTINATION ${CMAKE_INSTALL_LIBDIR}
    PERMISSIONS
        OWNER_READ OWNER_WRITE
        GROUP_READ
        WORLD_READ
)
if(WIN32 AND MSVC)
    install(
        FILES
            $<TARGET_PDB_FILE:Lua::Library>
        DESTINATION ${CMAKE_INSTALL_BINDIR}
        COMPONENT Library
    )
elseif(LINUX)
    install(
        FILES
            $<TARGET_FILE_DIR:Lua::Library>/$<TARGET_FILE_NAME:Lua::Library>.debug
        DESTINATION ${CMAKE_INSTALL_LIBDIR}
        COMPONENT Library
    )
elseif(APPLE AND CMAKE_GENERATOR MATCHES "Xcode")
    install(
        DIRECTORY
            $<TARGET_FILE_DIR:Lua::Library>/$<TARGET_FILE_NAME:Lua::Library>.dSYM
        DESTINATION ${CMAKE_INSTALL_LIBDIR}
        COMPONENT Library
    )
endif()

# Install includes
install(
    FILES
        ${CMAKE_CURRENT_SOURCE_DIR}/src/lua.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/luaconf.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/lualib.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/lauxlib.h
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/lua${LUA_VERSION}
    COMPONENT Library
)

# Install interpreter
if(LUA_ENABLE_INTERPRETER)
    install(
        TARGETS lua
        EXPORT LuaTargets
        RUNTIME
            COMPONENT Interpreter
            DESTINATION ${CMAKE_INSTALL_BINDIR}
        PERMISSIONS
            OWNER_READ OWNER_WRITE OWNER_EXECUTE
            GROUP_READ GROUP_EXECUTE
            WORLD_READ WORLD_EXECUTE
    )

    if(WIN32 AND MSVC)
        install(
            FILES
                $<TARGET_PDB_FILE:Lua::Interpreter>
            DESTINATION ${CMAKE_INSTALL_BINDIR}
            COMPONENT Interpreter
        )
    elseif(LINUX)
        install(
            FILES
                $<TARGET_FILE_DIR:Lua::Interpreter>/$<TARGET_FILE_NAME:Lua::Interpreter>.debug
            DESTINATION ${CMAKE_INSTALL_BINDIR}
            COMPONENT Interpreter
        )
    elseif(APPLE AND CMAKE_GENERATOR MATCHES "Xcode")
        install(
            DIRECTORY
                $<TARGET_FILE_DIR:Lua::Interpreter>/$<TARGET_FILE_NAME:Lua::Interpreter>.dSYM
            DESTINATION ${CMAKE_INSTALL_BINDIR}
            COMPONENT Interpreter
        )
    endif()
endif()

# Install compiler
if(LUA_ENABLE_COMPILER)
    install(
        TARGETS luac
        EXPORT LuaTargets
        RUNTIME
            COMPONENT Compiler
            DESTINATION ${CMAKE_INSTALL_BINDIR}
        PERMISSIONS
            OWNER_READ OWNER_WRITE OWNER_EXECUTE
            GROUP_READ GROUP_EXECUTE
            WORLD_READ WORLD_EXECUTE
    )

    if(WIN32 AND MSVC)
        install(
            FILES
                $<TARGET_PDB_FILE:Lua::Compiler>
            DESTINATION ${CMAKE_INSTALL_BINDIR}
            COMPONENT Compiler
        )
    elseif(LINUX)
        install(
            FILES
                $<TARGET_FILE_DIR:Lua::Compiler>/$<TARGET_FILE_NAME:Lua::Compiler>.debug
            DESTINATION ${CMAKE_INSTALL_BINDIR}
            COMPONENT Compiler
        )
    elseif(APPLE AND CMAKE_GENERATOR MATCHES "Xcode")
        install(
            DIRECTORY
                $<TARGET_FILE_DIR:Lua::Compiler>/$<TARGET_FILE_NAME:Lua::Compiler>.dSYM
            DESTINATION ${CMAKE_INSTALL_BINDIR}
            COMPONENT Compiler
        )
    endif()
endif()

# Install package config
configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/lua.pc.in
    ${CMAKE_CURRENT_BINARY_DIR}/pkgconfig/lua-${LUA_VERSION}.pc
    @ONLY
)
install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/pkgconfig/lua-${LUA_VERSION}.pc
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig
    COMPONENT Library
)

# Install documentation
configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/COPYRIGHT
    ${CMAKE_CURRENT_BINARY_DIR}/copyright
    COPYONLY
)
install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/copyright
    DESTINATION ${CMAKE_INSTALL_DATADIR}/doc/lua${LUA_VERSION}
)
if(LUA_ENABLE_INTERPRETER)
    install(
        FILES ${CMAKE_CURRENT_SOURCE_DIR}/doc/lua.1
        DESTINATION ${CMAKE_INSTALL_MANDIR}/man1
        COMPONENT Interpreter
    )
endif()
if(LUA_ENABLE_COMPILER)
    install(
        FILES ${CMAKE_CURRENT_SOURCE_DIR}/doc/luac.1
        DESTINATION ${CMAKE_INSTALL_MANDIR}/man1
        COMPONENT Compiler
    )
endif()

# Export targets
install(
    EXPORT LuaTargets
    FILE LuaTargets.cmake
    NAMESPACE Lua::
    DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/cmake
)

# Export config
include(CMakePackageConfigHelpers)
configure_package_config_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/LuaConfig.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/cmake/LuaConfig.cmake
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/lua-${LUA_VERSION}
    NO_SET_AND_CHECK_MACRO
    NO_CHECK_REQUIRED_COMPONENTS_MACRO
)
write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/cmake/LuaConfigVersion.cmake
    VERSION ${LUA_RELEASE}
    COMPATIBILITY AnyNewerVersion
)
install(
    FILES
        ${CMAKE_CURRENT_BINARY_DIR}/cmake/LuaConfig.cmake
        ${CMAKE_CURRENT_BINARY_DIR}/cmake/LuaConfigVersion.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/lua-${LUA_VERSION}
)
install(
    DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/cmake/
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/lua-${LUA_VERSION}
    FILES_MATCHING PATTERN "LuaTargets*.cmake"
)

# Replace prefix
configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/ReplacePrefix.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/ReplacePrefix.cmake
    @ONLY
)
install(SCRIPT ${CMAKE_CURRENT_BINARY_DIR}/ReplacePrefix.cmake)
