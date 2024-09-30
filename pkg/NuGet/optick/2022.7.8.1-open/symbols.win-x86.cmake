if($<CONFIG> STREQUAL "Debug")
    set(OPTICK_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(OPTICK_CONFIG "Release")
endif()

set(OPTICK_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(OPTICK_RUNTIME_ID "win-x86")
set(OPTICK_RUNTIME_PATH "${OPTICK_ROOT_PATH}/runtimes/${OPTICK_RUNTIME_ID}/native/$(OPTICK_CONFIG)/")

if(OPTICK_CONFIG STREQUAL "Debug")
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${OPTICK_RUNTIME_PATH}/OptickCored.pdb ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
elseif(OPTICK_CONFIG STREQUAL "Release")
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${OPTICK_RUNTIME_PATH}/OptickCore.pdb ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
endif()
