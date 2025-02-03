if($<CONFIG> STREQUAL "Debug")
    set(NVTT_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(NVTT_CONFIG "Release")
endif()

set(NVTT_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(NVTT_RUNTIME_ID "linux-x64")
set(NVTT_RUNTIME_PATH "${NVTT_ROOT_PATH}/runtimes/${NVTT_RUNTIME_ID}/native/${NVTT_CONFIG}")
set(NVTT_INCLUDE_PATH "${NVTT_ROOT_PATH}/build/native/include/")

target_include_directories(${PROJECT_NAME} PRIVATE "${NVTT_INCLUDE_PATH}")
target_link_directories(${PROJECT_NAME} PRIVATE "${NVTT_RUNTIME_PATH}")

target_link_libraries(${PROJECT_NAME} PRIVATE libnvcore.so)
target_link_libraries(${PROJECT_NAME} PRIVATE libnvimage.so)
target_link_libraries(${PROJECT_NAME} PRIVATE libnvmath.so)
target_link_libraries(${PROJECT_NAME} PRIVATE libnvthread.so)
target_link_libraries(${PROJECT_NAME} PRIVATE libnvtt.so)

add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${NVTT_RUNTIME_PATH}/libnvcore.so ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${NVTT_RUNTIME_PATH}/libnvimage.so ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${NVTT_RUNTIME_PATH}/libnvmath.so ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${NVTT_RUNTIME_PATH}/libnvthread.so ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${NVTT_RUNTIME_PATH}/libnvtt.so ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
)

if(NVTT_CONFIG STREQUAL "Debug")
    target_link_libraries(${PROJECT_NAME} PRIVATE libsquishd.so.0.0)

    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${NVTT_RUNTIME_PATH}/libsquishd.so.0.0 ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
    execute_process(
        COMMAND ln -s libsquishd.so.0.0 libsquishd.so
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
elseif(NVTT_CONFIG STREQUAL "Release")
    target_link_libraries(${PROJECT_NAME} PRIVATE libsquish.so.0.0)

    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${NVTT_RUNTIME_PATH}/libsquish.so.0.0 ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
    execute_process(
        COMMAND ln -s libsquish.so.0.0 libsquish.so
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
endif()
