if($<CONFIG> STREQUAL "Debug")
    set(EMBREE_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(EMBREE_CONFIG "Release")
endif()

set(EMBREE_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(EMBREE_RUNTIME_ID "linux-x64")
set(EMBREE_RUNTIME_PATH "${EMBREE_ROOT_PATH}/runtimes/${EMBREE_RUNTIME_ID}/native/$(EMBREE_CONFIG)/")
set(EMBREE_INCLUDE_PATH "${EMBREE_ROOT_PATH}/build/native/include/")

target_include_directories(${PROJECT_NAME} PRIVATE ${EMBREE_INCLUDE_PATH})
target_link_directories(${PROJECT_NAME} PRIVATE ${EMBREE_RUNTIME_PATH})

target_link_libraries(${PROJECT_NAME} PRIVATE libembree4.so.4)

add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EMBREE_RUNTIME_PATH}/libembree4.so.4.3.3 ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
)

execute_process(
    COMMAND ln -s libembree4.so.4.3.3 libembree4.so.4
    WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
)
execute_process(
    COMMAND ln -s libembree4.so.4 libembree4.so
    WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
)
