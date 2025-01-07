if($<CONFIG> STREQUAL "Debug")
    set(EMBREE_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(EMBREE_CONFIG "Release")
endif()

set(EMBREE_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(EMBREE_RUNTIME_ID "win-x64")
set(EMBREE_RUNTIME_PATH "${EMBREE_ROOT_PATH}/runtimes/${EMBREE_RUNTIME_ID}/native/$(EMBREE_CONFIG)/")
set(EMBREE_INCLUDE_PATH "${EMBREE_ROOT_PATH}/build/native/include/")

target_include_directories(${PROJECT_NAME} PRIVATE ${EMBREE_INCLUDE_PATH})
target_link_directories(${PROJECT_NAME} PRIVATE ${EMBREE_RUNTIME_PATH})

target_link_libraries(${PROJECT_NAME} PRIVATE embree4.lib)

add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EMBREE_RUNTIME_PATH}/embree4.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
)
