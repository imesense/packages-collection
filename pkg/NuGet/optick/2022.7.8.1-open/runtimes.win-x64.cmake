if($<CONFIG> STREQUAL "Debug")
    set(OPTICK_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(OPTICK_CONFIG "Release")
endif()

set(OPTICK_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(OPTICK_RUNTIME_ID "win-x64")
set(OPTICK_RUNTIME_PATH "${OPTICK_ROOT_PATH}/runtimes/${OPTICK_RUNTIME_ID}/native/$(OPTICK_CONFIG)/")
set(OPTICK_INCLUDE_PATH "${OPTICK_ROOT_PATH}/build/native/include/")

target_include_directories(${PROJECT_NAME} PRIVATE ${OPTICK_INCLUDE_PATH})
target_link_directories(${PROJECT_NAME} PRIVATE ${OPTICK_RUNTIME_PATH})

if(OPTICK_CONFIG STREQUAL "Debug")
    target_link_libraries(${PROJECT_NAME} PRIVATE OptickCored.lib)

    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${OPTICK_RUNTIME_PATH}/OptickCored.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
elseif(OPTICK_CONFIG STREQUAL "Release")
    target_link_libraries(${PROJECT_NAME} PRIVATE OptickCore.lib)

    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${OPTICK_RUNTIME_PATH}/OptickCore.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
endif()
