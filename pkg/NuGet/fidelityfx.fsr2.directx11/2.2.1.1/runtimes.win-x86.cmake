if($<CONFIG> STREQUAL "Debug")
    set(FSR2_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(FSR2_CONFIG "Release")
endif()

set(FSR2_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(FSR2_RUNTIME_ID "win-x86")
set(FSR2_RUNTIME_PATH "${FSR2_ROOT_PATH}/runtimes/${FSR2_RUNTIME_ID}/native/$(FSR2_CONFIG)/")
set(FSR2_INCLUDE_PATH "${FSR2_ROOT_PATH}/build/native/include/")

target_include_directories(${PROJECT_NAME} PRIVATE ${FSR2_INCLUDE_PATH})
target_link_directories(${PROJECT_NAME} PRIVATE ${FSR2_RUNTIME_PATH})

if(FSR2_CONFIG STREQUAL "Debug")
    target_link_libraries(${PROJECT_NAME} PRIVATE ffx_fsr2_api_x86d.lib)
    target_link_libraries(${PROJECT_NAME} PRIVATE ffx_fsr2_api_dx11_x86d.lib)

    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${FSR2_RUNTIME_PATH}/ffx_fsr2_api_x86d.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${FSR2_RUNTIME_PATH}/ffx_fsr2_api_dx11_x86d.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
elseif(FSR2_CONFIG STREQUAL "Release")
    target_link_libraries(${PROJECT_NAME} PRIVATE ffx_fsr2_api_x86.lib)
    target_link_libraries(${PROJECT_NAME} PRIVATE ffx_fsr2_api_dx11_x86.lib)

    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${FSR2_RUNTIME_PATH}/ffx_fsr2_api_x86.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${FSR2_RUNTIME_PATH}/ffx_fsr2_api_dx11_x86.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
endif()
