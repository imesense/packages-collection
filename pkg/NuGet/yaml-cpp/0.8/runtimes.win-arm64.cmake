if($<CONFIG> STREQUAL "Debug")
    set(YAMLCPP_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(YAMLCPP_CONFIG "Release")
endif()

set(YAMLCPP_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(YAMLCPP_RUNTIME_ID "win-arm64")
set(YAMLCPP_RUNTIME_PATH "${YAMLCPP_ROOT_PATH}/runtimes/${YAMLCPP_RUNTIME_ID}/native/$(YAMLCPP_CONFIG)/")
set(YAMLCPP_INCLUDE_PATH "${YAMLCPP_ROOT_PATH}/build/native/include/")

target_include_directories(${PROJECT_NAME} PRIVATE ${YAMLCPP_INCLUDE_PATH})
target_link_directories(${PROJECT_NAME} PRIVATE ${YAMLCPP_RUNTIME_PATH})

if($<CONFIG> STREQUAL "Debug")
    target_link_libraries(${PROJECT_NAME} PRIVATE yaml-cppd.lib)
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    target_link_libraries(${PROJECT_NAME} PRIVATE yaml-cpp.lib)
endif()

if($<CONFIG> STREQUAL "Debug")
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${YAMLCPP_RUNTIME_PATH}/yaml-cppd.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${YAMLCPP_RUNTIME_PATH}/yaml-cpp.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
endif()
