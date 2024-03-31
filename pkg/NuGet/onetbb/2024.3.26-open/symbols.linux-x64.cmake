if($<CONFIG> STREQUAL "Debug")
    set(ONETBB_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(ONETBB_CONFIG "Release")
endif()

set(ONETBB_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(ONETBB_RUNTIME_ID "linux-x64")
set(ONETBB_RUNTIME_PATH "${ONETBB_ROOT_PATH}/runtimes/${ONETBB_RUNTIME_ID}/native/$(ONETBB_CONFIG)/")

if(ONETBB_CONFIG STREQUAL "Debug")
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ONETBB_RUNTIME_PATH}/libtbb_debug.so.12.13.debug ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ONETBB_RUNTIME_PATH}/libtbbmalloc_debug.so.2.13.debug ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ONETBB_RUNTIME_PATH}/libtbbmalloc_proxy_debug.so.2.13.debug ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
elseif(ONETBB_CONFIG STREQUAL "Release")
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ONETBB_RUNTIME_PATH}/libtbb.so.12.13.debug ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ONETBB_RUNTIME_PATH}/libtbbmalloc.so.2.13.debug ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ONETBB_RUNTIME_PATH}/libtbbmalloc_proxy.so.2.13.debug ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
endif()
