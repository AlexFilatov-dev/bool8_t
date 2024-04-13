# set the project target properties
function(set_project_properties target)

    # set the c++ standart
    set_target_properties(${target}
                          PROPERTIES 
                          CXX_STANDARD ${${PROJECT_NAME}_CXX_STANDARD}
                          CXX_STANDARD_REQUIRED TRUE
                          CXX_EXTENSIONS FALSE)

    # set the build type postfix and suffix
    if(${PROJECT_NAME}_BUILD_SHARED_LIBS)
        set_target_properties(${target}  
                              PROPERTIES 
                              DEBUG_POSTFIX -d
                              RELWITHDEBINFO_POSTFIX -rwdi
                              MINSIZEREL_POSTFIX -msr)
                              
    else()
        set_target_properties(${target} 
                              PROPERTIES 
                              DEBUG_POSTFIX -s-d
                              RELWITHDEBINFO_POSTFIX -s-rwdi
                              MINSIZEREL_POSTFIX -s-msr
                              RELEASE_POSTFIX -s)
    endif()

    # select a MSVC runtime library
    if(${PROJECT_NAME}_USE_STATIC_STD_LIBS)
        set(cxx_std_lib "MultiThreaded$<$<CONFIG:Debug>:Debug>")
    else()
        set(cxx_std_lib "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL")
    endif()

    set_target_properties(${target}  
                          PROPERTIES 
                          MSVC_RUNTIME_LIBRARY ${cxx_std_lib})

endfunction()

# set the project target warning options
function(set_project_options target)

    # set compiler lists
    set(gcc_like_cxx "$<COMPILE_LANG_AND_ID:CXX,ARMClang,AppleClang,Clang,GNU,LCC>")
    set(msvc_cxx "$<COMPILE_LANG_AND_ID:CXX,MSVC>")

    # set warning flags
    target_compile_options(${target}
                           PRIVATE
                           "$<${gcc_like_cxx}:$<BUILD_INTERFACE:-Wall;-Wextra;-Wshadow;-Wformat=2;-Wunused>>"
                           "$<${gcc_like_cxx}:$<INSTALL_INTERFACE:-Wall;-Wextra;-Wshadow;-Wformat=2;-Wunused>>"
                           "$<${msvc_cxx}:$<BUILD_INTERFACE:-W3>>"
                           "$<${msvc_cxx}:$<INSTALL_INTERFACE:-W3>>")

endfunction()


# add a project library
# example: add_project_library(project_name-lib
#                              INCLUDES_PATH "include_path"                   # path of the includes subdirectory
#                              INCLUDES lib.hpp ...                           # library public headers
#                              [SOURCES lib.cpp ... ])                        # library private headers and sources
#                              [PUBLIC_DEPENDS extPublic::extPublic ... ])    # link the public dependencies
#                              [PRIVATE_DEPENDS extPrivate::extPrivate ... ]) # link the private dependencies
#
# This function adds the new library and sets it's propeties, compiler options and defenitions. Also it adds the
# library alias named as the last directory of the INCLUDES_PATH and sets the IDE folder named as the penultimate 
# directory of the INCLUDES_PATH or as the PROJECT_NAME if there no parent directory.
function(add_project_library target)

    # parse the function arguments
	cmake_parse_arguments("THIS" "" "INCLUDES_PATH" "INCLUDES;SOURCES;PUBLIC_DEPENDS;PRIVATE_DEPENDS" ${ARGN})

    if (DEFINED THIS_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Extra unparsed arguments when calling add_project_library: ${THIS_UNPARSED_ARGUMENTS}")
    endif()

    if(NOT DEFINED THIS_INCLUDES)
        message(FATAL_ERROR "INCLUDES is not used when calling add_project_library")
    endif()

    if(NOT DEFINED THIS_INCLUDES_PATH)       

        message(FATAL_ERROR "INCLUDES_PATH is not used when calling add_project_library")

    else() 

        # add the path to the header files
        list(TRANSFORM THIS_INCLUDES PREPEND "${THIS_INCLUDES_PATH}/")

        # set the header install dir 
        cmake_path(RELATIVE_PATH THIS_INCLUDES_PATH 
                   BASE_DIRECTORY ${PROJECT_SOURCE_DIR}/include
                   OUTPUT_VARIABLE install_include_subdirs)

        # does path has a parent folder?
        cmake_path(HAS_PARENT_PATH install_include_subdirs hasParentPath)

        if(NOT hasParentPath)
            # set the default value of the parent_folder and the module
            set(parent_folder ${install_include_subdirs})
            set(module ${install_include_subdirs})
        else()
            # set the parent folder 
            cmake_path(GET install_include_subdirs PARENT_PATH parent_folder)

            # set the module
            cmake_path(RELATIVE_PATH install_include_subdirs  
                       BASE_DIRECTORY ${parent_folder}
                       OUTPUT_VARIABLE module)
        endif()

    endif()

    # get a config name
    if(${PROJECT_NAME}_BUILD_SHARED_LIBS)
        set(config_name SHARED)
    else()
        set(config_name STATIC)
    endif()

    # add a library target
    add_library(${target}
                ${config_name}
                ${THIS_INCLUDES}
                ${THIS_SOURCES})

    
    # set the library alias
    add_library(${PROJECT_NAME}::${module} ALIAS ${target})

    # link the public dependencies 
    target_link_libraries(${target} 
                          PUBLIC
                          ${THIS_PUBLIC_DEPENDS})

    # link the private dependencies 
    target_link_libraries(${target} 
                          PRIVATE
                          ${THIS_PRIVATE_DEPENDS})

    # include the library build directories
    target_include_directories(${target}
                               PUBLIC
                               "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>")

    # set an install path
    if(${PROJECT_NAME}_FRAMEWORK)
        set(library_install_interface ${target}.framework)
    else()
        set(library_install_interface ${CMAKE_INSTALL_INCLUDEDIR})
    endif()

    # include the library install directories
    target_include_directories(${target}
                               PUBLIC
                               "$<INSTALL_INTERFACE:${library_install_interface}>")

    # set the library warning flags
    if(${PROJECT_NAME}_USE_WARNING_FLAGS)
        set_project_options(${target})
    endif()

    # set the project properties
    set_project_properties(${target})

    if(${PROJECT_NAME}_BUILD_SHARED_LIBS)

        # set a shared library suffix
        set_target_properties(${target}
                              PROPERTIES                             
                              SUFFIX -${PROJECT_VERSION_MAJOR}${CMAKE_SHARED_LIBRARY_SUFFIX})

        # hide the symbols of the shared libs
        set_target_properties(${target}
                              PROPERTIES
                              CXX_VISIBILITY_PRESET hidden
                              VISIBILITY_INLINES_HIDDEN TRUE)

        # set a Windows export flag
        if(WIN32)
            set_target_properties(${target}    
                                  PROPERTIES   
                                  DEFINE_SYMBOL 
                                  ${PROJECT_NAME}_EXPORTS)
        endif()

    else()

        # set a static flag
        target_compile_definitions(${target} 
                                   PUBLIC
                                   ${PROJECT_NAME}_STATIC)
    endif()

    # set the target's folder (for IDEs that support it, e.g. Visual Studio)
    set_target_properties(${target}
                          PROPERTIES
                          FOLDER ${parent_folder})

    # set the public headers                      
    set_target_properties(${target}
                          PROPERTIES
                          PUBLIC_HEADER "${THIS_INCLUDES}")

    # set the framework properties
	if(${PROJECT_NAME}_FRAMEWORK)
		set_target_properties(${target}
		                      PROPERTIES
                              FRAMEWORK TRUE
                              FRAMEWORK_VERSION ${PROJECT_VERSION}
							  FRAMEWORK_MULTI_CONFIG_POSTFIX_DEBUG _debug
                              MACOSX_FRAMEWORK_BUNDLE_VERSION ${PROJECT_VERSION}
                              MACOSX_FRAMEWORK_IDENTIFIER ${PROJECT_HOMEPAGE_URL})
	endif()

    # adapt an install directory to allow distributing dylibs/frameworks 
    # in user's frameworks/application bundle but only if cmake rpath options aren't set
    if(NOT CMAKE_SKIP_RPATH AND NOT CMAKE_SKIP_INSTALL_RPATH AND NOT CMAKE_INSTALL_RPATH 
       AND NOT CMAKE_INSTALL_RPATH_USE_LINK_PATH AND NOT CMAKE_INSTALL_NAME_DIR)
        set_target_properties(${target} 
                              PROPERTIES 
                              INSTALL_NAME_DIR "@rpath"
                              BUILD_WITH_INSTALL_RPATH TRUE)
    endif()
    
    # define export names
    set_target_properties(${target} 
                          PROPERTIES 
                          OUTPUT_NAME ${target}
                          EXPORT_NAME ${module})

    # install the target
    install(TARGETS ${target}
            EXPORT ${PROJECT_NAME}Targets
            RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR} COMPONENT ${module} 
            LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR} COMPONENT ${module} 
            ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR} COMPONENT ${module} 
            PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${install_include_subdirs} COMPONENT ${module}
            FRAMEWORK DESTINATION "." COMPONENT ${module})

    # install a pdb file
    if(WIN32)

        if(MSVC)
            set(pdb_dir "$<TARGET_FILE_DIR:${target}>")
            set(pdb_config_name "$<TARGET_FILE_BASE_NAME:${target}>.pdb")
            install(FILES "${pdb_dir}/${pdb_config_name}"
                    DESTINATION ${CMAKE_INSTALL_LIBDIR}
                    COMPONENT ${module} 
                    OPTIONAL)
        endif()

    endif()

endfunction()


# add an project example
# example: add_project_executable(example
#                                 SOURCES ex.cpp ...       # headers and sources
#                                 [RESOURCES_DIR resorces] # resources sudirectory 
#                                 [RESOURCES ex.png ... ]  # resources
#                                 DEPENDS depend_lib ...)  # dependent targets
#
# This function adds the new execution and sets it's propeties, compiler options and defenitions. Also it sets the 
# IDE folder named as the penultimate directory of the INCLUDES_PATH or as the PROJECT_NAME if there no parent directory.
function(add_project_executable target)

    # parse the function arguments
	cmake_parse_arguments("THIS" "" "RESOURCES_DIR" "SOURCES;RESOURCES;DEPENDS" ${ARGN}) 

    # throw error if the function has an unparced arguments
    if (DEFINED THIS_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Extra unparsed arguments when calling add_project_executable: ${THIS_UNPARSED_ARGUMENTS}")
    endif()

    if(NOT DEFINED THIS_SOURCES)
        message(FATAL_ERROR "SOURCES is not used when calling add_project_library")
    endif()

    if(NOT DEFINED THIS_DEPENDS)
        message(FATAL_ERROR "DEPENDS is not used when calling add_project_library")
    endif()

    if((DEFINED THIS_RESOURCES) AND (NOT DEFINED THIS_RESOURCES_DIR))
        message(FATAL_ERROR "RESOURCES is used but RESOURCES_DIR not used when calling add_project_library")
    endif()

    # add the path to the resoure files
    if(DEFINED THIS_RESOURCES_DIR)
        list(TRANSFORM THIS_RESOURCES PREPEND "${THIS_RESOURCES_DIR}/")
    endif()

    # set the header install dir 
    cmake_path(RELATIVE_PATH CMAKE_CURRENT_SOURCE_DIR 
                BASE_DIRECTORY ${PROJECT_SOURCE_DIR}
                OUTPUT_VARIABLE install_sources_subdirs)

    # does path has a parent folder?
    cmake_path(HAS_PARENT_PATH install_sources_subdirs hasParentPath)

    if(NOT hasParentPath)
        set(parent_folder ${install_sources_subdirs})
    else()
        # set the parent folder 
        cmake_path(GET install_sources_subdirs PARENT_PATH parent_folder)
    endif()

    # add an example target
    add_executable(${target}
                   ${THIS_SOURCES}
                   ${THIS_RESOURCES})

    # link the dependencies 
    target_link_libraries(${target} 
                          PRIVATE
                          ${THIS_DEPENDS})

    # set the library warning flags
    if(${PROJECT_NAME}_USE_WARNING_FLAGS)
        set_project_options(${target})
    endif()

    # set the properties
    set_project_properties(${target})

    # set the target's folder (for IDEs that support it, e.g. Visual Studio)
    set_target_properties(${target}
                          PROPERTIES
                          FOLDER ${parent_folder})

    # set the public headers                      
    set_target_properties(${target}
                          PROPERTIES
                          RESOURCE "${THIS_RESOURCES}")

    # set the bundle properties
    if(IOS)
        # Bare executables are not usable on iOS, only bundle applications
        set_target_properties(${target} 
                              PROPERTIES
                              MACOSX_BUNDLE TRUE 
                              MACOSX_BUNDLE_BUNDLE_NAME ${target}
                              MACOSX_BUNDLE_LONG_VERSION_STRING ${PROJECT_VERSION})
    endif()
	
    # copy the resources directory to the build directory	
	if(DEFINED THIS_RESOURCES_DIR)
		add_custom_command(TARGET ${target} 
						   POST_BUILD
						   COMMAND ${CMAKE_COMMAND} -E copy_directory
						   "${CMAKE_CURRENT_SOURCE_DIR}/${THIS_RESOURCES_DIR}"
						   "$<TARGET_FILE_DIR:${target}>/${THIS_RESOURCES_DIR}")		
	endif()
	
	# copy the dll dependencies to the build directory
	if(WIN32 AND ${PROJECT_NAME}_BUILD_SHARED_LIBS)
		add_custom_command(TARGET ${target} POST_BUILD
						   COMMAND ${CMAKE_COMMAND} -E copy
						   "$<TARGET_RUNTIME_DLLS:${target}>" 
						   "$<TARGET_FILE_DIR:${target}>"
						   COMMAND_EXPAND_LISTS)		
	endif()
	
    # install the source files	
    install(FILES ${THIS_SOURCES}
            DESTINATION ${install_sources_subdirs}
            COMPONENT ${parent_folder})

    # install the target
    install(TARGETS ${target}
            RUNTIME DESTINATION ${install_sources_subdirs} COMPONENT ${parent_folder}
            RESOURCE DESTINATION ${install_sources_subdirs}/${THIS_RESOURCES_DIR} COMPONENT ${parent_folder})
    
    if(WIN32)

        # install a pdb file
        if(MSVC)
            set(PDB_DIR "$<TARGET_FILE_DIR:${target}>")
            set(CURRENT_PDB_NAME "$<TARGET_FILE_BASE_NAME:${target}>.pdb")
            install(FILES "${PDB_DIR}/${CURRENT_PDB_NAME}"
                    DESTINATION ${install_sources_subdirs}
                    COMPONENT ${parent_folder}
                    OPTIONAL)
        endif()

    endif()    

endfunction()


# make the project package using CPack
function(project_package)

    # get a config name
    if(${PROJECT_NAME}_BUILD_SHARED_LIBS)
        set(config_name Shared)
    else()
        set(config_name Static)
    endif()

    # set the CPack properties
    set(CPACK_PACKAGE_VENDOR "${PROJECT_NAME} team")
    set(CPACK_PACKAGE_FILE_NAME ${PROJECT_NAME}-${PROJECT_VERSION}-${CMAKE_SYSTEM_NAME}-${config_name})
    set(CPACK_PACKAGE_INSTALL_DIRECTORY ${PROJECT_NAME}-${PROJECT_VERSION}-${config_name})
    set(CPACK_RESOURCE_FILE_LICENSE "${PROJECT_SOURCE_DIR}/license.md")
	set(CPACK_RESOURCE_FILE_README "${PROJECT_SOURCE_DIR}/readme.md")
    set(CPACK_MONOLITHIC_INSTALL ON)

    # set the NSIS properties
    set(CPACK_NSIS_ENABLE_UNINSTALL_BEFORE_INSTALL ON)
    set(CPACK_NSIS_DISPLAY_NAME ${PROJECT_NAME})

    # make a CPack config file
    include(CPack)

endfunction()


# export the project
function(project_export)

    # get a config name
    if(${PROJECT_NAME}_BUILD_SHARED_LIBS)
        set(config_name Shared)
    else()
        set(config_name Static)
    endif()

    # set an export targets file
    set(export_targets_file ${PROJECT_NAME}${config_name}Targets.cmake)

    # set an install directory of the export files
    if (${PROJECT_NAME}_FRAMEWORK)
        set(exports_install_dir ${target}.framework/Resources/CMake)
    else()
        set(exports_install_dir ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME})
    endif()

    # install the export targets file
    install(EXPORT ${PROJECT_NAME}Targets
            FILE ${export_targets_file}
            NAMESPACE ${PROJECT_NAME}::
            DESTINATION ${exports_install_dir})

    # generate the export targets file for the build tree
    export(EXPORT ${PROJECT_NAME}Targets
           FILE "${PROJECT_BINARY_DIR}/${export_targets_file}"
           NAMESPACE ${PROJECT_NAME}::)

    include(CMakePackageConfigHelpers)

    # generate an export config file
    configure_package_config_file(cmake/${PROJECT_NAME}Config.cmake.in
                                  ${PROJECT_NAME}Config.cmake
                                  INSTALL_DESTINATION ${exports_install_dir}
                                  NO_SET_AND_CHECK_MACRO
                                  NO_CHECK_REQUIRED_COMPONENTS_MACRO)

    # generate a version file for the export config file
    write_basic_package_version_file(${PROJECT_NAME}ConfigVersion.cmake
                                     COMPATIBILITY SameMajorVersion)

    # install the generated export configuration files
    install(FILES
            "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
            "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
            DESTINATION ${exports_install_dir})

endfunction()