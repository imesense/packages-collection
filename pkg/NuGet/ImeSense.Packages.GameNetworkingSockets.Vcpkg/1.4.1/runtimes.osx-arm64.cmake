if($<CONFIG> STREQUAL "Debug")
    set(GAME_NETWORKING_SOCKETS_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(GAME_NETWORKING_SOCKETS_CONFIG "Release")
endif()

set(GAME_NETWORKING_SOCKETS_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(GAME_NETWORKING_SOCKETS_RUNTIME_ID "osx-arm64")
set(GAME_NETWORKING_SOCKETS_RUNTIME_PATH "${GAME_NETWORKING_SOCKETS_ROOT_PATH}/runtimes/${GAME_NETWORKING_SOCKETS_RUNTIME_ID}/native/$(GAME_NETWORKING_SOCKETS_CONFIG)/")
set(GAME_NETWORKING_SOCKETS_INCLUDE_PATH "${GAME_NETWORKING_SOCKETS_ROOT_PATH}/build/native/include/")

include_directories(${GAME_NETWORKING_SOCKETS_INCLUDE_PATH})
link_directories(${GAME_NETWORKING_SOCKETS_RUNTIME_PATH})

target_link_libraries(${PROJECT_NAME} PRIVATE libcrypto.3.dylib)
target_link_libraries(${PROJECT_NAME} PRIVATE libGameNetworkingSockets.dylib)
target_link_libraries(${PROJECT_NAME} PRIVATE libssl.3.dylib)

add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${GAME_NETWORKING_SOCKETS_RUNTIME_PATH}/libcrypto.3.dylib ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
)
add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${GAME_NETWORKING_SOCKETS_RUNTIME_PATH}/libGameNetworkingSockets.dylib ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
)
add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${GAME_NETWORKING_SOCKETS_RUNTIME_PATH}/libssl.3.dylib ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
)

execute_process(
    COMMAND ln -s libcrypto.3.dylib libcrypto.dylib
    WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
)
execute_process(
    COMMAND ln -s libssl.3.dylib libssl.dylib
    WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
)

if(GAME_NETWORKING_SOCKETS_CONFIG STREQUAL "Debug")
    target_link_libraries(${PROJECT_NAME} PRIVATE libprotobufd.3.21.8.0.dylib)
    target_link_libraries(${PROJECT_NAME} PRIVATE libprotobuf-lited.3.21.8.0.dylib)
    target_link_libraries(${PROJECT_NAME} PRIVATE libprotocd.3.21.8.0.dylib)

    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${GAME_NETWORKING_SOCKETS_RUNTIME_PATH}/libprotobufd.3.21.8.0.dylib ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${GAME_NETWORKING_SOCKETS_RUNTIME_PATH}/libprotobuf-lited.3.21.8.0.dylib ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${GAME_NETWORKING_SOCKETS_RUNTIME_PATH}/libprotocd.3.21.8.0.dylib ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )

    execute_process(
        COMMAND ln -s libprotobufd.3.21.8.0.dylib libprotobufd.32.dylib
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libprotobufd.32.dylib libprotobufd.dylib
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libprotobuf-lited.3.21.8.0.dylib libprotobuf-lited.32.dylib
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libprotobuf-lited.32.dylib libprotobuf-lited.dylib
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libprotocd.3.21.8.0.dylib libprotocd.32.dylib
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libprotocd.32.dylib libprotocd.dylib
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
elseif(GAME_NETWORKING_SOCKETS_CONFIG STREQUAL "Release")
    target_link_libraries(${PROJECT_NAME} PRIVATE libprotobuf.3.21.8.0.dylib)
    target_link_libraries(${PROJECT_NAME} PRIVATE libprotobuf-lite.3.21.8.0.dylib)
    target_link_libraries(${PROJECT_NAME} PRIVATE libprotoc.3.21.8.0.dylib)

    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${GAME_NETWORKING_SOCKETS_RUNTIME_PATH}/libprotobuf.3.21.8.0.dylib ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${GAME_NETWORKING_SOCKETS_RUNTIME_PATH}/libprotobuf-lite.3.21.8.0.dylib ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${GAME_NETWORKING_SOCKETS_RUNTIME_PATH}/libprotoc.3.21.8.0.dylib ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )

    execute_process(
        COMMAND ln -s libprotobuf.3.21.8.0.dylib libprotobuf.32.dylib
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libprotobuf.32.dylib libprotobuf.dylib
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libprotobuf-lite.3.21.8.0.dylib libprotobuf-lite.32.dylib
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libprotobuf-lite.32.dylib libprotobuf-lite.dylib
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libprotoc.3.21.8.0.dylib libprotoc.32.dylib
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
    execute_process(
        COMMAND ln -s libprotoc.32.dylib libprotoc.dylib
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
endif()
