set(LUAJIT_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(LUAJIT_RUNTIME_ID "win-x86")
set(LUAJIT_RUNTIME_PATH "${LUAJIT_ROOT_PATH}/runtimes/${LUAJIT_RUNTIME_ID}/native/")
set(LUAJIT_INCLUDE_PATH "${LUAJIT_ROOT_PATH}/build/native/include/")

target_include_directories(${PROJECT_NAME} PRIVATE "${LUAJIT_INCLUDE_PATH}")
target_link_directories(${PROJECT_NAME} PRIVATE "${LUAJIT_RUNTIME_PATH}")

target_link_libraries(${PROJECT_NAME} PRIVATE lua51.lib)

add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LUAJIT_RUNTIME_PATH}/lua51.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
)
