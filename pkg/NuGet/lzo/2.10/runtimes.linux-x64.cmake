if($<CONFIG> STREQUAL "Debug")
    set(LZO_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(LZO_CONFIG "Release")
endif()

set(LZO_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(LZO_RUNTIME_ID "linux-x64")
set(LZO_RUNTIME_PATH "${LZO_ROOT_PATH}/runtimes/${LZO_RUNTIME_ID}/native/$(LZO_CONFIG)/")
set(LZO_INCLUDE_PATH "${LZO_ROOT_PATH}/build/native/include/")

target_include_directories(${PROJECT_NAME} PRIVATE ${LZO_INCLUDE_PATH})
target_link_directories(${PROJECT_NAME} PRIVATE ${LZO_RUNTIME_PATH})

target_link_libraries(${PROJECT_NAME} PRIVATE liblzo2.so.2.0.0)

add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LZO_RUNTIME_PATH}/liblzo2.so.2.0.0 ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
)

execute_process(
    COMMAND ln -s liblzo2.so.2.0.0 liblzo2.so.2
    COMMAND ln -s liblzo2.so.2 liblzo2.so
    WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
)
