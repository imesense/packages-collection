if($<CONFIG> STREQUAL "Debug")
    set(NVTT_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(NVTT_CONFIG "Release")
endif()

set(NVTT_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(NVTT_RUNTIME_ID "osx-arm64")
set(NVTT_RUNTIME_PATH "${NVTT_ROOT_PATH}/runtimes/${NVTT_RUNTIME_ID}/native/${NVTT_CONFIG}")

add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${NVTT_RUNTIME_PATH}/libnvcore.dylib.dSYM ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/libnvcore.dylib.dSYM
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${NVTT_RUNTIME_PATH}/libnvimage.dylib.dSYM ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/libnvimage.dylib.dSYM
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${NVTT_RUNTIME_PATH}/libnvmath.dylib.dSYM ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/libnvmath.dylib.dSYM
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${NVTT_RUNTIME_PATH}/libnvthread.dylib.dSYM ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/libnvthread.dylib.dSYM
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${NVTT_RUNTIME_PATH}/libnvtt.dylib.dSYM ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/libnvtt.dylib.dSYM
)
