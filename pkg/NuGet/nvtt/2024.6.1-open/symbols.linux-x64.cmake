if($<CONFIG> STREQUAL "Debug")
    set(NVTT_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(NVTT_CONFIG "Release")
endif()

set(NVTT_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(NVTT_RUNTIME_ID "linux-x64")
set(NVTT_RUNTIME_PATH "${NVTT_ROOT_PATH}/runtimes/${NVTT_RUNTIME_ID}/native/${NVTT_CONFIG}")

add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${NVTT_RUNTIME_PATH}/libnvcore.so.debug ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${NVTT_RUNTIME_PATH}/libnvimage.so.debug ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${NVTT_RUNTIME_PATH}/libnvmath.so.debug ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${NVTT_RUNTIME_PATH}/libnvthread.so.debug ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${NVTT_RUNTIME_PATH}/libnvtt.so.debug ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
)

if(NVTT_CONFIG STREQUAL "Debug")
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${NVTT_RUNTIME_PATH}/libsquishd.so.0.0.debug ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
elseif(NVTT_CONFIG STREQUAL "Release")
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${NVTT_RUNTIME_PATH}/libsquish.so.0.0.debug ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
endif()
