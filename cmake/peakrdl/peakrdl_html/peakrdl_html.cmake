function(peakrdl_html RTLLIB)
    cmake_parse_arguments(ARG "SERVER_TARGET" "OUTDIR" "" ${ARGN})
    if(ARG_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION} passed unrecognized argument " "${ARG_UNPARSED_ARGUMENTS}")
    endif()

    include("${CMAKE_CURRENT_FUNCTION_LIST_DIR}/../../rtllib.cmake")

    get_target_property(BINARY_DIR ${RTLLIB} BINARY_DIR)

    if(NOT ARG_OUTDIR)
        set(OUTDIR ${BINARY_DIR}/html)
    else()
        set(OUTDIR ${ARG_OUTDIR})
    endif()

    get_rtl_target_property(RDL_FILES ${RTLLIB} RDL_FILES)

    if(RDL_FILES STREQUAL "RDL_FILES-NOTFOUND")
        message(FATAL_ERROR "Library ${RTLLIB} does not have RDL_FILES property set, unable to run ${CMAKE_CURRENT_FUNCTION}")
    endif()

    set(STAMP_FILE "${BINARY_DIR}/${RTLLIB}_${CMAKE_CURRENT_FUNCTION}.stamp")
    add_custom_command(
        OUTPUT ${OUTDIR} ${STAMP_FILE}
        COMMAND peakrdl  html
            -o ${OUTDIR} 
            ${RDL_FILES}

        COMMAND touch ${STAMP_FILE}
        DEPENDS ${RDL_FILES}
        COMMENT "Running ${CMAKE_CURRENT_FUNCTION} on ${RTLLIB}"
        )

    add_custom_target(
        ${RTLLIB}_${CMAKE_CURRENT_FUNCTION}
        DEPENDS ${OUTDIR} ${STAMP_FILE}
        )

    if(ARG_SERVER_TARGET)
        add_custom_target(${RTLLIB}_${CMAKE_CURRENT_FUNCTION}_server
            COMMAND python3 -m http.server -d "${OUTDIR}"
            DEPENDS ${RTLLIB}_${CMAKE_CURRENT_FUNCTION}
            )
    endif()

    # get_target_property(DEPENDS ${RTLLIB} DEPENDS)
    add_dependencies(${RTLLIB}_${CMAKE_CURRENT_FUNCTION} ${RTLLIB})
    # set_property(TARGET ${RTLLIB} APPEND PROPERTY DEPENDS ${RTLLIB}_regblock) # TODO maybe add this
endfunction()


