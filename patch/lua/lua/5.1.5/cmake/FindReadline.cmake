include(FindPackageHandleStandardArgs)

find_path(Readline_Readline_INCLUDE
    NAMES
        readline/readline.h
    PATHS
        /usr/include
        /usr/local/include
)
find_library(Readline_Readline_LIBRARY
    NAMES
        readline
    PATHS
        /usr/lib
        /usr/local/lib
)

find_path(Readline_History_INCLUDE
    NAMES
        readline/readline.h
    PATHS
        /usr/include
        /usr/local/include
)
find_library(Readline_History_LIBRARY
    NAMES
        history
    PATHS
        /usr/lib
        /usr/local/lib
)

find_package_handle_standard_args(Readline
    REQUIRED_VARS
        Readline_Readline_INCLUDE
        Readline_Readline_LIBRARY
        Readline_History_INCLUDE
        Readline_History_LIBRARY
)

if(Readline_Readline_FOUND)
    mark_as_advanced(Readline_Readline_INCLUDE)
    mark_as_advanced(Readline_Readline_LIBRARY)
endif()

if(Readline_History_FOUND)
    mark_as_advanced(Readline_History_INCLUDE)
    mark_as_advanced(Readline_History_LIBRARY)
endif()

if(NOT Readline::Library::Readline)
    add_library(Readline::Library::Readline UNKNOWN IMPORTED)
    set_target_properties(Readline::Library::Readline
        PROPERTIES
            IMPORTED_LOCATION ${Readline_Readline_LIBRARY}
            INTERFACE_INCLUDE_DIRECTORIES ${Readline_Readline_INCLUDE}
    )
endif()

if(NOT Readline::Library::History)
    add_library(Readline::Library::History UNKNOWN IMPORTED)
    set_target_properties(Readline::Library::History
        PROPERTIES
            IMPORTED_LOCATION ${Readline_History_LIBRARY}
            INTERFACE_INCLUDE_DIRECTORIES ${Readline_History_INCLUDE}
    )
endif()
