# set a library headers directory
set(include_dir "${PROJECT_SOURCE_DIR}/include/${PROJECT_NAME}")

# set the project config file paths
set(config_file_input "${include_dir}/Config.hpp.in")
set(config_file_output "${include_dir}/Config.hpp")

# make the project config file
configure_file("${include_dir}/Config.hpp.in"
               "${include_dir}/Config.hpp"
               @ONLY)

# install the project config file
install(FILES 
        "${include_dir}/Config.hpp"
        DESTINATION
        ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME})

# add the libraries
add_project_library(bool8_t
                    INCLUDES_PATH "${include_dir}"
                    INCLUDES bool8_t.hpp
                    SOURCES bool8_t.cpp)