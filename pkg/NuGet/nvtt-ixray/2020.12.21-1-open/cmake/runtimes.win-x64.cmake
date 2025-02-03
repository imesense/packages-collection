if($<CONFIG> STREQUAL "Debug")
    set(NVTT_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(NVTT_CONFIG "Release")
endif()

set(NVTT_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(NVTT_RUNTIME_ID "win-x64")
set(NVTT_RUNTIME_PATH "${NVTT_ROOT_PATH}/runtimes/${NVTT_RUNTIME_ID}/native/${NVTT_CONFIG}")
set(NVTT_INCLUDE_PATH "${NVTT_ROOT_PATH}/build/native/include/")

target_include_directories(${PROJECT_NAME} PRIVATE "${NVTT_INCLUDE_PATH}")
target_link_directories(${PROJECT_NAME} PRIVATE "${NVTT_RUNTIME_PATH}")

target_link_libraries(${PROJECT_NAME} PRIVATE nvtt.lib)

add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${NVTT_RUNTIME_PATH}/nvtt.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
)
