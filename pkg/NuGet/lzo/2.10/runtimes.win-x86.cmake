if($<CONFIG> STREQUAL "Debug")
    set(LZO_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(LZO_CONFIG "Release")
endif()

set(LZO_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(LZO_RUNTIME_ID "win-x86")
set(LZO_RUNTIME_PATH "${LZO_ROOT_PATH}/runtimes/${LZO_RUNTIME_ID}/native/$(LZO_CONFIG)/")
set(LZO_INCLUDE_PATH "${LZO_ROOT_PATH}/build/native/include/")

target_include_directories(${PROJECT_NAME} PRIVATE ${LZO_INCLUDE_PATH})
target_link_directories(${PROJECT_NAME} PRIVATE ${LZO_RUNTIME_PATH})

target_link_libraries(${PROJECT_NAME} PRIVATE lzo2.lib)

add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LZO_RUNTIME_PATH}/lzo2.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
)
