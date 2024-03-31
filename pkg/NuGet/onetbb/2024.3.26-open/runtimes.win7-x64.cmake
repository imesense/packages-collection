if($<CONFIG> STREQUAL "Debug")
    set(ONETBB_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(ONETBB_CONFIG "Release")
endif()

set(ONETBB_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(ONETBB_RUNTIME_ID "win7-x64")
set(ONETBB_RUNTIME_PATH "${ONETBB_ROOT_PATH}/runtimes/${ONETBB_RUNTIME_ID}/native/$(ONETBB_CONFIG)/")
set(ONETBB_INCLUDE_PATH "${ONETBB_ROOT_PATH}/build/native/include/")

include_directories(${ONETBB_INCLUDE_PATH})
link_directories(${ONETBB_RUNTIME_PATH})

if(ONETBB_CONFIG STREQUAL "Debug")
    target_link_libraries(${PROJECT_NAME} PRIVATE tbb_debug.lib)
    target_link_libraries(${PROJECT_NAME} PRIVATE tbb12_debug.lib)
    target_link_libraries(${PROJECT_NAME} PRIVATE tbbmalloc_debug.lib)
    target_link_libraries(${PROJECT_NAME} PRIVATE tbbmalloc_proxy_debug.lib)

    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ONETBB_RUNTIME_PATH}/tbb12_debug.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ONETBB_RUNTIME_PATH}/tbbmalloc_debug.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ONETBB_RUNTIME_PATH}/tbbmalloc_proxy_debug.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
elseif(ONETBB_CONFIG STREQUAL "Release")
    target_link_libraries(${PROJECT_NAME} PRIVATE tbb.lib)
    target_link_libraries(${PROJECT_NAME} PRIVATE tbb12.lib)
    target_link_libraries(${PROJECT_NAME} PRIVATE tbbmalloc.lib)
    target_link_libraries(${PROJECT_NAME} PRIVATE tbbmalloc_proxy.lib)

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
endif()
