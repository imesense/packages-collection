# Return if not enabled testing
if(NOT LUA_ENABLE_TESTS)
    return()
endif()
if(NOT LUA_ENABLE_INTERPRETER AND NOT LUA_ENABLE_COMPILER)
    return()
endif()

enable_testing()

# Clean results
if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/luac.out)
    file(REMOVE ${CMAKE_CURRENT_SOURCE_DIR}/luac.out)
endif()

# Run tests
add_test(
    NAME bisect
    COMMAND $<TARGET_FILE:lua> ${CMAKE_CURRENT_SOURCE_DIR}/bisect.lua
)
add_test(
    NAME cf
    COMMAND $<TARGET_FILE:lua> ${CMAKE_CURRENT_SOURCE_DIR}/cf.lua
)
add_test(
    NAME echo
    COMMAND $<TARGET_FILE:lua> ${CMAKE_CURRENT_SOURCE_DIR}/echo.lua echo
)
add_test(
    NAME env
    COMMAND $<TARGET_FILE:lua> ${CMAKE_CURRENT_SOURCE_DIR}/env.lua
)
add_test(
    NAME factorial
    COMMAND $<TARGET_FILE:lua> ${CMAKE_CURRENT_SOURCE_DIR}/factorial.lua
)
add_test(
    NAME fib
    COMMAND $<TARGET_FILE:lua> ${CMAKE_CURRENT_SOURCE_DIR}/fib.lua
)
add_test(
    NAME fibfor
    COMMAND $<TARGET_FILE:lua> ${CMAKE_CURRENT_SOURCE_DIR}/fibfor.lua
)
add_test(
    NAME hello
    COMMAND $<TARGET_FILE:lua> ${CMAKE_CURRENT_SOURCE_DIR}/hello.lua
)
add_test(
    NAME life
    COMMAND $<TARGET_FILE:lua> ${CMAKE_CURRENT_SOURCE_DIR}/life.lua
)
add_test(
    NAME luac
    COMMAND $<TARGET_FILE:lua> ${CMAKE_CURRENT_SOURCE_DIR}/luac.lua hello.lua
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)
add_test(
    NAME printf
    COMMAND $<TARGET_FILE:lua> ${CMAKE_CURRENT_SOURCE_DIR}/printf.lua
)
add_test(
    NAME sieve
    COMMAND $<TARGET_FILE:lua> -e N=1000 ${CMAKE_CURRENT_SOURCE_DIR}/sieve.lua
)
add_test(
    NAME sort
    COMMAND $<TARGET_FILE:lua> ${CMAKE_CURRENT_SOURCE_DIR}/sort.lua
)
add_test(
    NAME trace-calls
    COMMAND $<TARGET_FILE:lua> -ltrace-calls ${CMAKE_CURRENT_SOURCE_DIR}/bisect.lua
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)
add_test(
    NAME trace-globals
    COMMAND $<TARGET_FILE:lua> ${CMAKE_CURRENT_SOURCE_DIR}/trace-globals.lua
)

set(globals_pass_pattern "setmetatable: 6[\r\n\t ]*")
if(WIN32)
    add_test(
        NAME globals
        COMMAND powershell -Command "$<TARGET_FILE:luac> -p -l ${CMAKE_CURRENT_SOURCE_DIR}/readonly.lua | $<TARGET_FILE:lua> ${CMAKE_CURRENT_SOURCE_DIR}/globals.lua | sort | $<TARGET_FILE:lua> ${CMAKE_CURRENT_SOURCE_DIR}/table.lua"
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )
    set_tests_properties(globals
        PROPERTIES
            PASS_REGULAR_EXPRESSION ${globals_pass_pattern}
    )
elseif(UNIX)
    add_test(
        NAME globals
        COMMAND "/usr/bin/env" "bash" "-c" "$<TARGET_FILE:luac> -p -l ${CMAKE_CURRENT_SOURCE_DIR}/readonly.lua | $<TARGET_FILE:lua> ${CMAKE_CURRENT_SOURCE_DIR}/globals.lua | sort | $<TARGET_FILE:lua> ${CMAKE_CURRENT_SOURCE_DIR}/table.lua"
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )
    set_tests_properties(globals
        PROPERTIES
            PASS_REGULAR_EXPRESSION ${globals_pass_pattern}
    )
endif()

set(xd_pass_pattern "00000000  2D 2D 20 68 65 78 20 64 75 6D 70 0A 2D 2D 20 75  -- hex dump.-- u[\r\n\t ]*")
if(WIN32)
    add_test(
        NAME xd
        COMMAND powershell -Command "Get-Content ${CMAKE_CURRENT_SOURCE_DIR}/xd.lua | $<TARGET_FILE:lua> ${CMAKE_CURRENT_SOURCE_DIR}/xd.lua"
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )
    set_tests_properties(xd
        PROPERTIES
            PASS_REGULAR_EXPRESSION ${xd_pass_pattern}
    )
elseif(UNIX)
    add_test(
        NAME xd
        COMMAND "/usr/bin/env" "bash" "-c" "$<TARGET_FILE:lua> ${CMAKE_CURRENT_SOURCE_DIR}/xd.lua < ${CMAKE_CURRENT_SOURCE_DIR}/xd.lua"
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )
    set_tests_properties(xd
        PROPERTIES
            PASS_REGULAR_EXPRESSION ${xd_pass_pattern}
    )
endif()
