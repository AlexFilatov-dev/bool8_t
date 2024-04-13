# find a Doxygen
find_package(Doxygen REQUIRED)

if(NOT DOXYGEN_FOUND)
    message(FATAL_ERROR "Doxygen is needed to build the documentation")
endif()

# make the doxygen config file
configure_file(Doxyfile.in 
               Doxyfile
               @ONLY)

# make the documentation
add_custom_target(doc ALL
                  COMMAND ${CMAKE_COMMAND} -E echo_append "Building API Documentation..."
                  COMMAND ${DOXYGEN_EXECUTABLE} Doxyfile
                  COMMAND ${CMAKE_COMMAND} -E echo "Done."
                  WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")

# install the documentation
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.tag
        DESTINATION doc
        COMPONENT doc)
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/html
        DESTINATION doc
        COMPONENT doc)