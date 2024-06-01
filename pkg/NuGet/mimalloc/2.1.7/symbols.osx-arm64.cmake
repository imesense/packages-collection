if($<CONFIG> STREQUAL "Debug")
    set(MIMALLOC_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(MIMALLOC_CONFIG "Release")
endif()

set(MIMALLOC_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(MIMALLOC_RUNTIME_ID "osx-arm64")
set(MIMALLOC_RUNTIME_PATH "${MIMALLOC_ROOT_PATH}/runtimes/${MIMALLOC_RUNTIME_ID}/native/$(MIMALLOC_CONFIG)/")

add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${MIMALLOC_RUNTIME_PATH}/libmimalloc.2.1.dylib.dSYM ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/libmimalloc.2.1.dylib.dSYM
)
