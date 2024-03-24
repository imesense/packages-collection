if($<CONFIG> STREQUAL "Debug")
    set(GAME_NETWORKING_SOCKETS_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(GAME_NETWORKING_SOCKETS_CONFIG "Release")
endif()

set(GAME_NETWORKING_SOCKETS_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(GAME_NETWORKING_SOCKETS_RUNTIME_ID "win-x64")
set(GAME_NETWORKING_SOCKETS_RUNTIME_PATH "${GAME_NETWORKING_SOCKETS_ROOT_PATH}/runtimes/${GAME_NETWORKING_SOCKETS_RUNTIME_ID}/native/$(GAME_NETWORKING_SOCKETS_CONFIG)/")
set(GAME_NETWORKING_SOCKETS_INCLUDE_PATH "${GAME_NETWORKING_SOCKETS_ROOT_PATH}/build/native/include/")

include_directories(${GAME_NETWORKING_SOCKETS_INCLUDE_PATH})
link_directories(${GAME_NETWORKING_SOCKETS_RUNTIME_PATH})

target_link_libraries(${PROJECT_NAME} PRIVATE GameNetworkingSockets.lib)
target_link_libraries(${PROJECT_NAME} PRIVATE libcrypto.lib)
target_link_libraries(${PROJECT_NAME} PRIVATE libssl.lib)

add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${GAME_NETWORKING_SOCKETS_RUNTIME_PATH}/GameNetworkingSockets.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
)
add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${GAME_NETWORKING_SOCKETS_RUNTIME_PATH}/legacy.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
)
add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${GAME_NETWORKING_SOCKETS_RUNTIME_PATH}/libcrypto-3.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
)
add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${GAME_NETWORKING_SOCKETS_RUNTIME_PATH}/libssl-3.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
)

if(GAME_NETWORKING_SOCKETS_CONFIG STREQUAL "Debug")
    target_link_libraries(${PROJECT_NAME} PRIVATE libprotobuf-lited.lib)
    target_link_libraries(${PROJECT_NAME} PRIVATE libprotobufd.lib)
    target_link_libraries(${PROJECT_NAME} PRIVATE libprotocd.lib)

    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${GAME_NETWORKING_SOCKETS_RUNTIME_PATH}/libprotobuf-lited.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${GAME_NETWORKING_SOCKETS_RUNTIME_PATH}/libprotobufd.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${GAME_NETWORKING_SOCKETS_RUNTIME_PATH}/libprotocd.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
elseif(GAME_NETWORKING_SOCKETS_CONFIG STREQUAL "Release")
    target_link_libraries(${PROJECT_NAME} PRIVATE libprotobuf-lite.lib)
    target_link_libraries(${PROJECT_NAME} PRIVATE libprotobuf.lib)
    target_link_libraries(${PROJECT_NAME} PRIVATE libprotoc.lib)

    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${GAME_NETWORKING_SOCKETS_RUNTIME_PATH}/libprotobuf-lite.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${GAME_NETWORKING_SOCKETS_RUNTIME_PATH}/libprotobuf.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${GAME_NETWORKING_SOCKETS_RUNTIME_PATH}/libprotoc.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
endif()
