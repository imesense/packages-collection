if($<CONFIG> STREQUAL "Debug")
    set(ONETBB_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(ONETBB_CONFIG "Release")
endif()

set(ONETBB_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(ONETBB_RUNTIME_ID "osx-x64")
set(ONETBB_RUNTIME_PATH "${ONETBB_ROOT_PATH}/runtimes/${ONETBB_RUNTIME_ID}/native/$(ONETBB_CONFIG)/")

if(ONETBB_CONFIG STREQUAL "Debug")
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${ONETBB_RUNTIME_PATH}/libtbb_debug.12.11.dylib.dSYM ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/libtbb_debug.12.11.dylib.dSYM
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${ONETBB_RUNTIME_PATH}/libtbbmalloc_debug.2.11.dylib.dSYM ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/libtbbmalloc_debug.2.11.dylib.dSYM
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${ONETBB_RUNTIME_PATH}/libtbbmalloc_proxy_debug.2.11.dylib.dSYM ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/libtbbmalloc_proxy_debug.2.11.dylib.dSYM
    )
elseif(ONETBB_CONFIG STREQUAL "Release")
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${ONETBB_RUNTIME_PATH}/libtbb.12.11.dylib.dSYM ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/libtbb.12.11.dylib.dSYM
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${ONETBB_RUNTIME_PATH}/libtbbmalloc.2.11.dylib.dSYM ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/libtbbmalloc.2.11.dylib.dSYM
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${ONETBB_RUNTIME_PATH}/libtbbmalloc_proxy.2.11.dylib.dSYM ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/libtbbmalloc_proxy.2.11.dylib.dSYM
    )
endif()
