if($<CONFIG> STREQUAL "Debug")
    set(GAME_NETWORKING_SOCKETS_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(GAME_NETWORKING_SOCKETS_CONFIG "Release")
endif()

set(GAME_NETWORKING_SOCKETS_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(GAME_NETWORKING_SOCKETS_RUNTIME_ID "linux-x64")
set(GAME_NETWORKING_SOCKETS_RUNTIME_PATH "${GAME_NETWORKING_SOCKETS_ROOT_PATH}/runtimes/${GAME_NETWORKING_SOCKETS_RUNTIME_ID}/native/$(GAME_NETWORKING_SOCKETS_CONFIG)/")
set(GAME_NETWORKING_SOCKETS_INCLUDE_PATH "${GAME_NETWORKING_SOCKETS_ROOT_PATH}/build/native/include/")

include_directories(${GAME_NETWORKING_SOCKETS_INCLUDE_PATH})
link_directories(${GAME_NETWORKING_SOCKETS_RUNTIME_PATH})

target_link_libraries(${PROJECT_NAME} PRIVATE libcrypto.so.3)
target_link_libraries(${PROJECT_NAME} PRIVATE libGameNetworkingSockets.so)
target_link_libraries(${PROJECT_NAME} PRIVATE libssl.so.3)

add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${GAME_NETWORKING_SOCKETS_RUNTIME_PATH}/libcrypto.so.3 ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
)
add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${GAME_NETWORKING_SOCKETS_RUNTIME_PATH}/libGameNetworkingSockets.so ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
)
add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${GAME_NETWORKING_SOCKETS_RUNTIME_PATH}/libssl.so.3 ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
)

execute_process(
    COMMAND ln -s libcrypto.so.3 libcrypto.so
    WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
)
execute_process(
    COMMAND ln -s libssl.so.3 libssl.so
    WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
)

if(GAME_NETWORKING_SOCKETS_CONFIG STREQUAL "Debug")
    target_link_libraries(${PROJECT_NAME} PRIVATE libprotobufd.so.3.21.8.0)
    target_link_libraries(${PROJECT_NAME} PRIVATE libprotobuf-lited.so.3.21.8.0)
    target_link_libraries(${PROJECT_NAME} PRIVATE libprotocd.so.3.21.8.0)

    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${GAME_NETWORKING_SOCKETS_RUNTIME_PATH}/libprotobufd.so.3.21.8.0 ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${GAME_NETWORKING_SOCKETS_RUNTIME_PATH}/libprotobuf-lited.so.3.21.8.0 ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${GAME_NETWORKING_SOCKETS_RUNTIME_PATH}/libprotocd.so.3.21.8.0 ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )

    execute_process(
        COMMAND ln -s libprotobufd.so.3.21.8.0 libprotobufd.so.32
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libprotobufd.so.32 libprotobufd.so
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libprotobuf-lited.so.3.21.8.0 libprotobuf-lited.so.32
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libprotobuf-lited.so.32 libprotobuf-lited.so
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libprotocd.so.3.21.8.0 libprotocd.so.32
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libprotocd.so.32 libprotocd.so
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
elseif(GAME_NETWORKING_SOCKETS_CONFIG STREQUAL "Release")
    target_link_libraries(${PROJECT_NAME} PRIVATE libprotobuf.so.3.21.8.0)
    target_link_libraries(${PROJECT_NAME} PRIVATE libprotobuf-lite.so.3.21.8.0)
    target_link_libraries(${PROJECT_NAME} PRIVATE libprotoc.so.3.21.8.0)

    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${GAME_NETWORKING_SOCKETS_RUNTIME_PATH}/libprotobuf.so.3.21.8.0 ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${GAME_NETWORKING_SOCKETS_RUNTIME_PATH}/libprotobuf-lite.so.3.21.8.0 ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${GAME_NETWORKING_SOCKETS_RUNTIME_PATH}/libprotoc.so.3.21.8.0 ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )

    execute_process(
        COMMAND ln -s libprotobuf.so.3.21.8.0 libprotobuf.so.32
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libprotobuf.so.32 libprotobuf.so
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libprotobuf-lite.so.3.21.8.0 libprotobuf-lite.so.32
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libprotobuf-lite.so.32 libprotobuf-lite.so
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libprotoc.so.3.21.8.0 libprotoc.so.32
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libprotoc.so.32 libprotoc.so
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
endif()
