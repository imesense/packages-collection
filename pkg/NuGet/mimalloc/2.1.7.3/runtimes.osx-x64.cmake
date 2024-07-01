if($<CONFIG> STREQUAL "Debug")
    set(MIMALLOC_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(MIMALLOC_CONFIG "Release")
endif()

set(MIMALLOC_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(MIMALLOC_RUNTIME_ID "osx-x64")
set(MIMALLOC_RUNTIME_PATH "${MIMALLOC_ROOT_PATH}/runtimes/${MIMALLOC_RUNTIME_ID}/native/$(MIMALLOC_CONFIG)/")
set(MIMALLOC_INCLUDE_PATH "${MIMALLOC_ROOT_PATH}/build/native/include/")

target_include_directories(${PROJECT_NAME} PRIVATE ${MIMALLOC_INCLUDE_PATH})
target_link_directories(${PROJECT_NAME} PRIVATE ${MIMALLOC_RUNTIME_PATH})

target_link_libraries(${PROJECT_NAME} PRIVATE libmimalloc.2.1.dylib)

add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${MIMALLOC_RUNTIME_PATH}/libmimalloc.2.1.dylib ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
)

execute_process(
    COMMAND ln -s libmimalloc.2.1.dylib libmimalloc.2.dylib
    COMMAND ln -s libmimalloc.2.dylib libmimalloc.dylib
    WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
)
