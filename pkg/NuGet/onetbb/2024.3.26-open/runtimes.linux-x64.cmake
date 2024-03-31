if($<CONFIG> STREQUAL "Debug")
    set(ONETBB_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(ONETBB_CONFIG "Release")
endif()

set(ONETBB_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(ONETBB_RUNTIME_ID "linux-x64")
set(ONETBB_RUNTIME_PATH "${ONETBB_ROOT_PATH}/runtimes/${ONETBB_RUNTIME_ID}/native/$(ONETBB_CONFIG)/")
set(ONETBB_INCLUDE_PATH "${ONETBB_ROOT_PATH}/build/native/include/")

include_directories(${ONETBB_INCLUDE_PATH})
link_directories(${ONETBB_RUNTIME_PATH})

if(ONETBB_CONFIG STREQUAL "Debug")
    target_link_libraries(${PROJECT_NAME} PRIVATE libtbb_debug.so.12.13)
    target_link_libraries(${PROJECT_NAME} PRIVATE libtbbmalloc_debug.so.2.13)
    target_link_libraries(${PROJECT_NAME} PRIVATE libtbbmalloc_proxy_debug.so.2.13)

    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ONETBB_RUNTIME_PATH}/libtbb_debug.so.12.13 ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ONETBB_RUNTIME_PATH}/libtbbmalloc_debug.so.2.13 ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ONETBB_RUNTIME_PATH}/libtbbmalloc_proxy_debug.so.2.13 ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )

    execute_process(
        COMMAND ln -s libtbb_debug.so.12.13 libtbb_debug.so.12
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libtbb_debug.so.12 libtbb_debug.so
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libtbbmalloc_debug.so.2.13 libtbbmalloc_debug.so.2
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libtbbmalloc_debug.so.2 libtbbmalloc_debug.so
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libtbbmalloc_proxy_debug.so.2.13 libtbbmalloc_proxy_debug.so.2
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libtbbmalloc_proxy_debug.so.2 libtbbmalloc_proxy_debug.so
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
elseif(ONETBB_CONFIG STREQUAL "Release")
    target_link_libraries(${PROJECT_NAME} PRIVATE tbb.lib)
    target_link_libraries(${PROJECT_NAME} PRIVATE tbb12.lib)
    target_link_libraries(${PROJECT_NAME} PRIVATE tbbmalloc.lib)

    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ONETBB_RUNTIME_PATH}/tbb12.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ONETBB_RUNTIME_PATH}/tbbmalloc.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ONETBB_RUNTIME_PATH}/tbbmalloc_proxy.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )

    execute_process(
        COMMAND ln -s libtbb.so.12.13 libtbb.so.12
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libtbb.so.12 libtbb.so
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libtbbmalloc.so.2.13 libtbbmalloc.so.2
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libtbbmalloc.so.2 libtbbmalloc.so
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libtbbmalloc_proxy.so.2.13 libtbbmalloc_proxy.so.2
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libtbbmalloc_proxy.so.2 libtbbmalloc_proxy.so
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
endif()
