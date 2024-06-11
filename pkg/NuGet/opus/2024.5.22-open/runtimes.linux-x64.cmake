if($<CONFIG> STREQUAL "Debug")
    set(OPUS_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(OPUS_CONFIG "Release")
endif()

set(OPUS_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(OPUS_RUNTIME_ID "linux-x64")
set(OPUS_RUNTIME_PATH "${OPUS_ROOT_PATH}/runtimes/${OPUS_RUNTIME_ID}/native/${OPUS_CONFIG}/")
set(OPUS_INCLUDE_PATH "${OPUS_ROOT_PATH}/build/native/include/")

target_include_directories(${PROJECT_NAME} PRIVATE ${OPUS_INCLUDE_PATH})
target_link_directories(${PROJECT_NAME} PRIVATE ${OPUS_RUNTIME_PATH})

target_link_libraries(${PROJECT_NAME} PRIVATE libopus.so.0.10.1)

add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${OPUS_RUNTIME_PATH}/libopus.so.0.10.1 ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
)

execute_process(
    COMMAND ln -s libopus.so.0.10.1 libopus.so.0
    COMMAND ln -s libopus.so.0 libopus.so
    WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
)
