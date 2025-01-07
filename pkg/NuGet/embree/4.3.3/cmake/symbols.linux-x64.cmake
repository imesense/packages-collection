if($<CONFIG> STREQUAL "Debug")
    set(EMBREE_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(EMBREE_CONFIG "Release")
endif()

set(EMBREE_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(EMBREE_RUNTIME_ID "linux-x64")
set(EMBREE_RUNTIME_PATH "${EMBREE_ROOT_PATH}/runtimes/${EMBREE_RUNTIME_ID}/native/$(EMBREE_CONFIG)/")

add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EMBREE_RUNTIME_PATH}/libembree4.so.4.3.3.debug ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
)
