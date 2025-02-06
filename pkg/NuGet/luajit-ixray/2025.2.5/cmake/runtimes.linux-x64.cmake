set(LUAJIT_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(LUAJIT_RUNTIME_ID "linux-x64")
set(LUAJIT_RUNTIME_PATH "${LUAJIT_ROOT_PATH}/runtimes/${LUAJIT_RUNTIME_ID}/native/")
set(LUAJIT_INCLUDE_PATH "${LUAJIT_ROOT_PATH}/build/native/include/")

target_include_directories(${PROJECT_NAME} PRIVATE "${LUAJIT_INCLUDE_PATH}")
target_link_directories(${PROJECT_NAME} PRIVATE "${LUAJIT_RUNTIME_PATH}")

target_link_libraries(${PROJECT_NAME} PRIVATE libluajit.so.2.0)

add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LUAJIT_RUNTIME_PATH}/libluajit.so.2.0 ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
)

execute_process(
    COMMAND ln -s libluajit.so.2.0 libluajit.so.2
    WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
)
execute_process(
    COMMAND ln -s libluajit.so.2 libluajit.so
    WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
)
