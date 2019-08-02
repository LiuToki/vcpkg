# Common Ambient Variables:
#   CURRENT_BUILDTREES_DIR    = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR      = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#   CURRENT_PORT_DIR          = ${VCPKG_ROOT_DIR}\ports\${PORT}
#   PORT                      = current port name (zlib, etc)
#   TARGET_TRIPLET            = current triplet (x86-windows, x64-windows-static, etc)
#   VCPKG_CRT_LINKAGE         = C runtime linkage type (static, dynamic)
#   VCPKG_LIBRARY_LINKAGE     = target library linkage type (static, dynamic)
#   VCPKG_ROOT_DIR            = <C:\path\to\current\vcpkg>
#   VCPKG_TARGET_ARCHITECTURE = target architecture (x64, x86, arm)
#

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Siv3D/OpenSiv3D
    REF e8814b4bb2baf23fcfc300325f700b842cce79b1
    SHA512 9be3496593e95e8bd931ea38fc559bc38ad2a31371c801e6c5255b049a0444d3a89f59f37c6e90d3f0fcc939eb3086354390b61f25d258e2e87f7df34206acb0
    HEAD_REF master
)

if (VCPKG_TARGET_ARCHITECTURE MATCHES "x64")
    set(BUILD_ARCH "x64")
    set(OUTPUT_DIR "Windows")
else()
    message(FATAL_ERROR "Unsupported architecture: ${VCPKG_TARGET_ARCHITECTURE}")
endif()

# List depending libraries before build
# file(GLOB_RECURSE LIBS ${SOURCE_PATH}/Siv3D/lib/${OUTPUT_DIR}/*.lib)

# download boost.
file(DOWNLOAD "https://dl.bintray.com/boostorg/release/1.70.0/source/boost_1_70_0.zip"
    ${SOURCE_PATH}/Dependencies/boost_1_70_0.zip
    STATUS download_status
    )
vcpkg_extract_source_archive(${SOURCE_PATH}/Dependencies/boost_1_70_0.zip ${SOURCE_PATH}/Dependencies)

vcpkg_build_msbuild(
    PROJECT_PATH ${SOURCE_PATH}/WindowsDesktop/Siv3D.vcxproj
    PLATFORM ${BUILD_ARCH}
    OPTIONS_DEBUG /p:OutDir=${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/
    OPTIONS_RELEASE /p:OutDir=${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/
    OPTIONS /VERBOSITY:Diagnostic /DETAILEDSUMMARY
)

# Handle headers
file(COPY ${SOURCE_PATH}/Siv3D/include/Siv3D.hpp DESTINATION ${CURRENT_PACKAGES_DIR}/include/opensiv3d)
file(COPY ${SOURCE_PATH}/Siv3D/include/HamFramework.hpp DESTINATION ${CURRENT_PACKAGES_DIR}/include/opensiv3d)
file(COPY ${SOURCE_PATH}/Siv3D/include/HamFramework DESTINATION ${CURRENT_PACKAGES_DIR}/include/opensiv3d)
file(COPY ${SOURCE_PATH}/Siv3D/include/Siv3D DESTINATION ${CURRENT_PACKAGES_DIR}/include/opensiv3d)
file(COPY ${SOURCE_PATH}/Siv3D/include/ThirdParty DESTINATION ${CURRENT_PACKAGES_DIR}/include/opensiv3d)

# Handle libraries
set(LIBRARY_OUT_DIRECTORY ${CURRENT_PACKAGES_DIR}/lib/opensiv3d)
set(LIBRARY_DEBUG_OUT_DIRECTORY ${CURRENT_PACKAGES_DIR}/debug/lib/opensiv3d)
file(MAKE_DIRECTORY ${LIBRARY_OUT_DIRECTORY})
file(MAKE_DIRECTORY ${LIBRARY_DEBUG_OUT_DIRECTORY})

file(INSTALL ${SOURCE_PATH}/Siv3D/lib/${OUTPUT_DIR}/ DESTINATION ${LIBRARY_DEBUG_OUT_DIRECTORY} FILES_MATCHING PATTERN "*d.lib" PATTERN "*debug.lib")
file(INSTALL ${SOURCE_PATH}/Siv3D/lib/${OUTPUT_DIR}/ DESTINATION ${LIBRARY_OUT_DIRECTORY} FILES_MATCHING PATTERN "*.lib" PATTERN "*d.lib" EXCLUDE  PATTERN "*debug.lib" EXCLUDE)

#foreach(LIB IN LISTS LIBS)
#    if (${LIB} MATCHES "d.lib")
#        file(INSTALL ${LIB} DESTINATION ${LIBRARY_DEBUG_OUT_DIRECTORY})
#    else()
#        file(INSTALL ${LIB} DESTINATION ${LIBRARY_OUT_DIRECTORY})
#    endif()
#endforeach()

file(INSTALL ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/Siv3D.lib DESTINATION ${LIBRARY_OUT_DIRECTORY})
file(INSTALL ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/Siv3D_d.lib DESTINATION ${LIBRARY_DEBUG_OUT_DIRECTORY})

# Handle targets
file(INSTALL ${CURRENT_PORT_DIR}/opensiv3d.targets DESTINATION ${CURRENT_PACKAGES_DIR}/tools/opensiv3d/)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/opensiv3d RENAME copyright)

# Copy pdb
vcpkg_copy_pdbs()

message(STATUS "This package use extra library.\nYou should check the what library is in the ThirdParty directory.")
message(STATUS "Installing done")
