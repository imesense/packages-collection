if($<CONFIG> STREQUAL "Debug")
    set(OPUS_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(OPUS_CONFIG "Release")
endif()

set(OPUS_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(OPUS_RUNTIME_ID "osx-x64")
set(OPUS_RUNTIME_PATH "${OPUS_ROOT_PATH}/runtimes/${OPUS_RUNTIME_ID}/native/${OPUS_CONFIG}/")
set(OPUS_INCLUDE_PATH "${OPUS_ROOT_PATH}/build/native/include/")

target_include_directories(${PROJECT_NAME} PRIVATE ${OPUS_INCLUDE_PATH})
target_link_directories(${PROJECT_NAME} PRIVATE ${OPUS_RUNTIME_PATH})

target_link_libraries(${PROJECT_NAME} PRIVATE libopus.0.10.1.dylib)

add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${OPUS_RUNTIME_PATH}/libopus.0.10.1.dylib ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
)

execute_process(
    COMMAND ln -s libopus.0.10.1.dylib libopus.0.dylib
    COMMAND ln -s libopus.0.dylib libopus.dylib
    WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
)
