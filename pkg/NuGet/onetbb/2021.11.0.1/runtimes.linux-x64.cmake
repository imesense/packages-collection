if($<CONFIG> STREQUAL "Debug")
    set(ONETBB_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(ONETBB_CONFIG "Release")
endif()

set(ONETBB_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(ONETBB_RUNTIME_ID "linux-x64")
set(ONETBB_RUNTIME_PATH "${ONETBB_ROOT_PATH}/runtimes/${ONETBB_RUNTIME_ID}/native/$(ONETBB_CONFIG)/")
set(ONETBB_INCLUDE_PATH "${ONETBB_ROOT_PATH}/build/native/include/")

target_include_directories(${PROJECT_NAME} PRIVATE ${ONETBB_INCLUDE_PATH})
target_link_directories(${PROJECT_NAME} PRIVATE ${ONETBB_RUNTIME_PATH})

if(ONETBB_CONFIG STREQUAL "Debug")
    target_link_libraries(${PROJECT_NAME} PRIVATE libtbb_debug.so.12.11)
    target_link_libraries(${PROJECT_NAME} PRIVATE libtbbmalloc_debug.so.2.11)
    target_link_libraries(${PROJECT_NAME} PRIVATE libtbbmalloc_proxy_debug.so.2.11)

    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ONETBB_RUNTIME_PATH}/libtbb_debug.so.12.11 ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ONETBB_RUNTIME_PATH}/libtbbmalloc_debug.so.2.11 ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ONETBB_RUNTIME_PATH}/libtbbmalloc_proxy_debug.so.2.11 ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )

    execute_process(
        COMMAND ln -s libtbb_debug.so.12.11 libtbb_debug.so.12
        COMMAND ln -s libtbb_debug.so.12 libtbb_debug.so
        COMMAND ln -s libtbbmalloc_debug.so.2.11 libtbbmalloc_debug.so.2
        COMMAND ln -s libtbbmalloc_debug.so.2 libtbbmalloc_debug.so
        COMMAND ln -s libtbbmalloc_proxy_debug.so.2.11 libtbbmalloc_proxy_debug.so.2
        COMMAND ln -s libtbbmalloc_proxy_debug.so.2 libtbbmalloc_proxy_debug.so
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
elseif(ONETBB_CONFIG STREQUAL "Release")
    target_link_libraries(${PROJECT_NAME} PRIVATE libtbb.so.12.11)
    target_link_libraries(${PROJECT_NAME} PRIVATE libtbbmalloc.so.2.11)
    target_link_libraries(${PROJECT_NAME} PRIVATE libtbbmalloc_proxy.so.2.11)

    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ONETBB_RUNTIME_PATH}/libtbb.so.12.11 ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ONETBB_RUNTIME_PATH}/libtbbmalloc.so.2.11 ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ONETBB_RUNTIME_PATH}/libtbbmalloc_proxy.so.2.11 ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )

    execute_process(
        COMMAND ln -s libtbb.so.12.11 libtbb.so.12
        COMMAND ln -s libtbb.so.12 libtbb.so
        COMMAND ln -s libtbbmalloc.so.2.11 libtbbmalloc.so.2
        COMMAND ln -s libtbbmalloc.so.2 libtbbmalloc.so
        COMMAND ln -s libtbbmalloc_proxy.so.2.11 libtbbmalloc_proxy.so.2
        COMMAND ln -s libtbbmalloc_proxy.so.2 libtbbmalloc_proxy.so
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
endif()
