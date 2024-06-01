if($<CONFIG> STREQUAL "Debug")
    set(NVTT_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(NVTT_CONFIG "Release")
endif()

set(NVTT_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(NVTT_RUNTIME_ID "osx-arm64")
set(NVTT_RUNTIME_PATH "${NVTT_ROOT_PATH}/runtimes/${NVTT_RUNTIME_ID}/native/${NVTT_CONFIG}")
set(NVTT_INCLUDE_PATH "${NVTT_ROOT_PATH}/build/native/include/")

target_include_directories(${PROJECT_NAME} PRIVATE "${NVTT_INCLUDE_PATH}")
target_link_directories(${PROJECT_NAME} PRIVATE "${NVTT_RUNTIME_PATH}")

target_link_libraries(${PROJECT_NAME} PRIVATE libnvcore.dylib)
target_link_libraries(${PROJECT_NAME} PRIVATE libnvimage.dylib)
target_link_libraries(${PROJECT_NAME} PRIVATE libnvmath.dylib)
target_link_libraries(${PROJECT_NAME} PRIVATE libnvthread.dylib)
target_link_libraries(${PROJECT_NAME} PRIVATE libnvtt.dylib)

add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${NVTT_RUNTIME_PATH}/libnvcore.dylib ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${NVTT_RUNTIME_PATH}/libnvimage.dylib ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${NVTT_RUNTIME_PATH}/libnvmath.dylib ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${NVTT_RUNTIME_PATH}/libnvthread.dylib ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${NVTT_RUNTIME_PATH}/libnvtt.dylib ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
)
