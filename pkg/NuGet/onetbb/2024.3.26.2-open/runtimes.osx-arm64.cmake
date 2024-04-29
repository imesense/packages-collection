if($<CONFIG> STREQUAL "Debug")
    set(ONETBB_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(ONETBB_CONFIG "Release")
endif()

set(ONETBB_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(ONETBB_RUNTIME_ID "osx-arm64")
set(ONETBB_RUNTIME_PATH "${ONETBB_ROOT_PATH}/runtimes/${ONETBB_RUNTIME_ID}/native/$(ONETBB_CONFIG)/")
set(ONETBB_INCLUDE_PATH "${ONETBB_ROOT_PATH}/build/native/include/")

target_include_directories(${PROJECT_NAME} PRIVATE ${ONETBB_INCLUDE_PATH})
target_link_directories(${PROJECT_NAME} PRIVATE ${ONETBB_RUNTIME_PATH})

if(ONETBB_CONFIG STREQUAL "Debug")
    target_link_libraries(${PROJECT_NAME} PRIVATE libtbb_debug.12.13.dylib)
    target_link_libraries(${PROJECT_NAME} PRIVATE libtbbmalloc_debug.2.13.dylib)
    target_link_libraries(${PROJECT_NAME} PRIVATE libtbbmalloc_proxy_debug.2.13.dylib)

    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ONETBB_RUNTIME_PATH}/libtbb_debug.12.13.dylib ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ONETBB_RUNTIME_PATH}/libtbbmalloc_debug.2.13.dylib ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ONETBB_RUNTIME_PATH}/libtbbmalloc_proxy_debug.2.13.dylib ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )

    execute_process(
        COMMAND ln -s libtbb_debug.12.13.dylib libtbb_debug.12.dylib
        COMMAND ln -s libtbb_debug.12.dylib libtbb_debug.dylib
        COMMAND ln -s libtbbmalloc_debug.2.13.dylib libtbbmalloc_debug.2.dylib
        COMMAND ln -s libtbbmalloc_debug.2.dylib libtbbmalloc_debug.dylib
        COMMAND ln -s libtbbmalloc_proxy_debug.2.13.dylib libtbbmalloc_proxy_debug.2.dylib
        COMMAND ln -s libtbbmalloc_proxy_debug.2.dylib libtbbmalloc_proxy_debug.dylib
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
elseif(ONETBB_CONFIG STREQUAL "Release")
    target_link_libraries(${PROJECT_NAME} PRIVATE libtbb.12.13.dylib)
    target_link_libraries(${PROJECT_NAME} PRIVATE libtbbmalloc.2.13.dylib)
    target_link_libraries(${PROJECT_NAME} PRIVATE libtbbmalloc_proxy.2.13.dylib)

    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ONETBB_RUNTIME_PATH}/libtbb.12.13.dylib ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ONETBB_RUNTIME_PATH}/libtbbmalloc.2.13.dylib ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ONETBB_RUNTIME_PATH}/libtbbmalloc_proxy.2.13.dylib ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )

    execute_process(
        COMMAND ln -s libtbb.12.13.dylib libtbb.12.dylib
        COMMAND ln -s libtbb.12.dylib libtbb.dylib
        COMMAND ln -s libtbbmalloc.2.13.dylib libtbbmalloc.2.dylib
        COMMAND ln -s libtbbmalloc.2.dylib libtbbmalloc.dylib
        COMMAND ln -s libtbbmalloc_proxy.2.13.dylib libtbbmalloc_proxy.2.dylib
        COMMAND ln -s libtbbmalloc_proxy.2.dylib libtbbmalloc_proxy.dylib
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
endif()
