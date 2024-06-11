if($<CONFIG> STREQUAL "Debug")
    set(OPUS_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(OPUS_CONFIG "Release")
endif()

set(OPUS_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(OPUS_RUNTIME_ID "win-arm")
set(OPUS_RUNTIME_PATH "${OPUS_ROOT_PATH}/runtimes/${OPUS_RUNTIME_ID}/native/${OPUS_CONFIG}/")
set(OPUS_INCLUDE_PATH "${OPUS_ROOT_PATH}/build/native/include/")

target_include_directories(${PROJECT_NAME} PRIVATE ${OPUS_INCLUDE_PATH})
target_link_directories(${PROJECT_NAME} PRIVATE ${OPUS_RUNTIME_PATH})

target_link_libraries(${PROJECT_NAME} PRIVATE opus.lib)

add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${OPUS_RUNTIME_PATH}/opus.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
)
