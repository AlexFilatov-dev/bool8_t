cmake_minimum_required(VERSION 3.21 FATAL_ERROR)

# hide the shared libraries symbols
cmake_policy(SET CMP0063 NEW)

# select a MSVC runtime library
cmake_policy(SET CMP0091 NEW)

# set a project
project(bool8_t
        VERSION 1.0.0
        DESCRIPTION "Simple library for efficient memory usage of the boolean type"
        HOMEPAGE_URL "https://github.com/AlexFilatov-dev/bool8_t.git"
        LANGUAGES CXX)

# set the path for the CMake modules
set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

# include the system install directories
include(GNUInstallDirs)

# include the custom project functions 
include(Functions)

# enable the project folders
set_property(GLOBAL PROPERTY USE_FOLDERS TRUE)
set_property(GLOBAL PROPERTY PREDEFINED_TARGETS_FOLDER "CMake")

set(${PROJECT_NAME}_CXX_STANDARD 11 CACHE STRING "Choose a c++ standart")

if(${PROJECT_NAME}_CXX_STANDARD STREQUAL 98)
    message(FATAL_ERROR "The minimum required standard is C++11")
endif()

set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build")

# set the global options
option(${PROJECT_NAME}_BUILD_SHARED_LIBS "TRUE to build a shared library, FALSE to build a static library" TRUE)
option(${PROJECT_NAME}_USE_WARNING_FLAGS "TRUE to use the warning flags, FALSE otherwise" TRUE)
option(${PROJECT_NAME}_BUILD_EXAMPLES "TRUE to build the examples, FALSE otherwise" FALSE)
option(${PROJECT_NAME}_BUILD_DOC "TRUE to generate the documentation, FALSE otherwise" FALSE)

if(WIN32)
    option(${PROJECT_NAME}_USE_STATIC_STD_LIBS "TRUE to link the static c++ standart libraries, FALSE - shared" FALSE)
endif()

if(${PROJECT_NAME}_USE_STATIC_STD_LIBS AND ${PROJECT_NAME}_BUILD_SHARED_LIBS)
    message(FATAL_ERROR "${PROJECT_NAME}_USE_STATIC_STD_LIBS should not use with ${PROJECT_NAME}_BUILD_SHARED_LIBS")
endif()

if(APPLE)
    option(${PROJECT_NAME}_FRAMEWORK "TRUE to build the framework, FALSE otherwise" FALSE)
endif()

# add the CMake subdirectories
add_subdirectory(src/${PROJECT_NAME} lib)

if(${PROJECT_NAME}_BUILD_EXAMPLES)
    add_subdirectory(examples)
endif()

if(${PROJECT_NAME}_BUILD_DOC)
    add_subdirectory(doc)
endif()

# install the project license and readme files
install(FILES license.md DESTINATION ${CMAKE_INSTALL_DOCDIR})
install(FILES readme.md DESTINATION ${CMAKE_INSTALL_DOCDIR})

# make the project package using CPack
project_package()

# export the project
project_export()