if($<CONFIG> STREQUAL "Debug")
    set(LZO_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(LZO_CONFIG "Release")
endif()

set(LZO_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(LZO_RUNTIME_ID "osx-x64")
set(LZO_RUNTIME_PATH "${LZO_ROOT_PATH}/runtimes/${LZO_RUNTIME_ID}/native/$(LZO_CONFIG)/")

add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${NVTT_RUNTIME_PATH}/liblzo2.2.0.0.dylib.dSYM ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/liblzo2.2.0.0.dylib.dSYM
)
