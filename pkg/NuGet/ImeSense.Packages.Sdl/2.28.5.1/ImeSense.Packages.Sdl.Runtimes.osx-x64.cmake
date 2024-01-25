if($<CONFIG> STREQUAL "Debug")
    set(SDL_CONFIG "Debug")
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    set(SDL_CONFIG "Release")
endif()

set(SDL_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(SDL_RUNTIME_ID "osx-x64")
set(SDL_RUNTIME_PATH "${SDL_ROOT_PATH}/runtimes/${SDL_RUNTIME_ID}/native/$(SDL_CONFIG)/")
set(SDL_INCLUDE_PATH "${SDL_ROOT_PATH}/build/native/include/")

include_directories(${SDL_INCLUDE_PATH})
link_directories(${SDL_RUNTIME_PATH})

if($<CONFIG> STREQUAL "Debug")
    target_link_libraries(${PROJECT_NAME} PRIVATE libSDL2-2.0d.0.dylib)
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    target_link_libraries(${PROJECT_NAME} PRIVATE libSDL2-2.0.0.dylib)
endif()

if($<CONFIG> STREQUAL "Debug")
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${SDL_RUNTIME_PATH}/libSDL2-2.0d.0.dylib ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
    execute_process(
        COMMAND ln -s libSDL2-2.0d.0.dylib libSDL2-2.0d.dylib
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
elseif($<CONFIG> STREQUAL "Release" OR $<CONFIG> STREQUAL "MinSizeRel" OR $<CONFIG> STREQUAL "RelWithDebInfo")
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${SDL_RUNTIME_PATH}/libSDL2-2.0.0.dylib ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
    )
    execute_process(
        COMMAND ln -s libSDL2-2.0.0.dylib libSDL2-2.0.dylib
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
endif()
