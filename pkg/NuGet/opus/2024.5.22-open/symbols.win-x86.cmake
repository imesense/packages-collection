if($<CONFIG> STREQUAL "Debug")
    set(OPUS_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(OPUS_CONFIG "Release")
endif()

set(OPUS_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(OPUS_RUNTIME_ID "win-x86")
set(OPUS_RUNTIME_PATH "${OPUS_ROOT_PATH}/runtimes/${OPUS_RUNTIME_ID}/native/${OPUS_CONFIG}/")

add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${OPUS_RUNTIME_PATH}/opus.pdb ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
)
