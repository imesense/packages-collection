if($<CONFIG> STREQUAL "Debug")
    set(SPEEXDSP_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(SPEEXDSP_CONFIG "Release")
endif()

set(SPEEXDSP_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(SPEEXDSP_RUNTIME_ID "win-x86")
set(SPEEXDSP_RUNTIME_PATH "${SPEEXDSP_ROOT_PATH}/runtimes/${SPEEXDSP_RUNTIME_ID}/native/${SPEEXDSP_CONFIG}/")

add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${SPEEXDSP_RUNTIME_PATH}/speexdsp.pdb ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
)
