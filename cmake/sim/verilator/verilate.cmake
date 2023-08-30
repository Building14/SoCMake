function(verilate IP_LIB)
    set(OPTIONS "COVERAGE;TRACE;TRACE_FST;SYSTEMC;TRACE_STRUCTS;MAIN")
    set(ONE_PARAM_ARGS "PREFIX;TOP_MODULE;THREADS;TRACE_THREADS;DIRECTORY;EXECUTABLE_NAME")
    set(MULTI_PARAM_ARGS "VERILATOR_ARGS;OPT_SLOW;OPT_FAST;OPT_GLOBAL")

    cmake_parse_arguments(ARG 
        "${OPTIONS}"
        "${ONE_PARAM_ARGS}"
        "${MULTI_PARAM_ARGS}"
        ${ARGN})

    if(ARG_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION} passed unrecognized argument " "${ARG_UNPARSED_ARGUMENTS}")
    endif()

    enable_language(CXX C)      # We need to enable CXX and C for Verilator

    include("${CMAKE_CURRENT_FUNCTION_LIST_DIR}/../../hwip.cmake")

    ip_assume_last(IP_LIB ${IP_LIB})
    get_target_property(BINARY_DIR ${IP_LIB} BINARY_DIR)

    if(NOT ARG_DIRECTORY)
        set(DIRECTORY "${BINARY_DIR}/${IP_LIB}_verilate")
    else()
        set(DIRECTORY ${ARG_DIRECTORY})
    endif()

    ##################################
    ## Find verilator installation ###
    ##################################
    if(NOT VERILATOR_HOME)
        find_package(verilator REQUIRED
            HINTS ${VERISC_HOME}/open/* $ENV{VERISC_HOME}/open/*
            )
        set(VERILATOR_HOME "${verilator_DIR}/../../")
    endif()

    find_file(_VERILATED_H verilated.h REQUIRED
        HINTS ${VERILATOR_HOME}/include ${verilator_DIR}/include
        )
    get_filename_component(VERILATOR_INCLUDE_DIR ${_VERILATED_H} DIRECTORY)

    set(VERILATOR_ROOT ${VERILATOR_INCLUDE_DIR}/../)
    ##################################

    get_ip_include_directories(INCLUDE_DIRS ${IP_LIB})

    if(ARG_TOP_MODULE)
        set(ARG_TOP_MODULE ${ARG_TOP_MODULE})
    else()
        get_target_property(ARG_TOP_MODULE ${IP_LIB} IP_NAME)
    endif()

    if(ARG_PREFIX)
        set(PREFIX ${ARG_PREFIX})
    else()
        set(PREFIX V${ARG_TOP_MODULE})
    endif()

    get_ip_property(VERILATOR_ARGS ${IP_LIB} VERILATOR_ARGS)
    list(APPEND VERILATOR_ARGS ${ARG_VERILATOR_ARGS})

    get_ip_compile_definitions(COMP_DEFS ${IP_LIB})
    foreach(def ${COMP_DEFS})
        list(APPEND VERILATOR_ARGS -D${def})
    endforeach()

    get_ip_sources(V_SOURCES ${IP_LIB} VERILOG)          # TODO make merge source files group function
    get_ip_sources(SOURCES ${IP_LIB} SYSTEMVERILOG)
    list(PREPEND SOURCES ${V_SOURCES})

    get_ip_sources(CFG_FILE ${IP_LIB} VERILATOR_CFG)
    list(PREPEND SOURCES ${CFG_FILE})

    if(NOT SOURCES)
        message(FATAL_ERROR "Verilate function needs at least one VERILOG or SYSTEMVERILOG source added to the IP")
    endif()

    if(ARG_MAIN)
        list(APPEND VERILATOR_ARGS --main)
        if(ARG_EXECUTABLE_NAME)
            set(EXECUTABLE_NAME ${ARG_EXECUTABLE_NAME})
        else()
            set(EXECUTABLE_NAME ${IP_LIB}_verilator_tb)
        endif()
    endif()

    set(PASS_ADDITIONAL_MULTIPARAM SOURCES) # Additional parameters to pass
    set(PASS_ADDITIONAL_ONEPARAM DIRECTORY PREFIX)
    set(PASS_ADDITIONAL_OPTIONS)

    foreach(param ${MULTI_PARAM_ARGS} ${PASS_ADDITIONAL_MULTIPARAM})
        if(${param})
            string(REPLACE ";" "|" ARG_${param} "${${param}}")
        endif()
    endforeach()

    foreach(param ${MULTI_PARAM_ARGS} ${OPTIONS} ${ONE_PARAM_ARGS})
        if(ARG_${param})
            list(APPEND EXT_PRJ_ARGS "-DVERILATE_${param}=${ARG_${param}}")
            list(APPEND ARGUMENTS_LIST ${param})
        endif()
    endforeach()
    foreach(param ${PASS_ADDITIONAL_MULTIPARAM} ${PASS_ADDITIONAL_ONEPARAM} ${PASS_ADDITIONAL_OPTIONS})
        if(${param})
            list(APPEND EXT_PRJ_ARGS "-DVERILATE_${param}=${${param}}")
            list(APPEND ARGUMENTS_LIST ${param})
        endif()
    endforeach()
    string(REPLACE ";" "|" ARGUMENTS_LIST "${ARGUMENTS_LIST}")

    if(ARG_SYSTEMC)
        if(NOT SYSTEMC_HOME)
            find_package(SystemCLanguage REQUIRED
                HINTS ${VERISC_HOME}/open/* $ENV{VERISC_HOME}/open/*
                )
            set(SYSTEMC_HOME "${SystemCLanguage_DIR}/../../../")
        endif()
    endif()

    if(CMAKE_CXX_STANDARD)
        set(ARG_CMAKE_CXX_STANDARD "-DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}")
    endif()

    set(VERILATE_TARGET ${IP_LIB}_verilate)
    include(ExternalProject)
    ExternalProject_Add(${VERILATE_TARGET}
        DOWNLOAD_COMMAND ""
        SOURCE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/verilator"
        PREFIX ${DIRECTORY}
        BINARY_DIR ${DIRECTORY}
        LIST_SEPARATOR |
        BUILD_ALWAYS 1

        CMAKE_ARGS
            ${ARG_CMAKE_CXX_STANDARD}
            -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
            -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
            -DCMAKE_VERBOSE_MAKEFILE=${CMAKE_VERBOSE_MAKEFILE}
            -DCMAKE_RUNTIME_OUTPUT_DIRECTORY=${BINARY_DIR}

            -DTARGET=${ARG_TOP_MODULE}
            -DARGUMENTS_LIST=${ARGUMENTS_LIST}
            -DEXECUTABLE_NAME=${EXECUTABLE_NAME}
            ${EXT_PRJ_ARGS}
            -DVERILATOR_ROOT=${VERILATOR_ROOT}
            -DSYSTEMC_ROOT=${SYSTEMC_HOME}

        INSTALL_COMMAND ""
        DEPENDS ${IP_LIB}
        EXCLUDE_FROM_ALL 1
        ) 

    set_property(
        TARGET ${VERILATE_TARGET}
        APPEND PROPERTY ADDITIONAL_CLEAN_FILES 
            ${DIRECTORY}
            ${BINARY_DIR}/${EXECUTABLE_NAME}
    )

    set(VLT_STATIC_LIB "${DIRECTORY}/lib${ARG_TOP_MODULE}.a")
    set(INC_DIR ${DIRECTORY})

    set(VERILATED_LIB ${IP_LIB}__vlt)
    add_library(${VERILATED_LIB} STATIC IMPORTED)
    add_dependencies(${VERILATED_LIB} ${VERILATE_TARGET})
    set_target_properties(${VERILATED_LIB} PROPERTIES IMPORTED_LOCATION ${VLT_STATIC_LIB})

    target_include_directories(${VERILATED_LIB} INTERFACE ${INC_DIR})
    target_include_directories(${VERILATED_LIB} INTERFACE
        "${VERILATOR_INCLUDE_DIR}"
        "${VERILATOR_INCLUDE_DIR}/vltstd")

    set(THREADS_PREFER_PTHREAD_FLAG ON)
    find_package(Threads REQUIRED)

    target_link_libraries(${VERILATED_LIB} INTERFACE -pthread)

    get_target_property(TYPE ${VERILATED_LIB} TYPE)

    string(REPLACE "__" "::" ALIAS_NAME "${VERILATED_LIB}")
    add_library(${ALIAS_NAME} ALIAS ${VERILATED_LIB})
endfunction()
