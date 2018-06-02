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
    REF 0014a6e05c43e8c820364ec5c20b46c6694b2b58
    SHA512 c459cb5dc99ed08fc0b52e02b517ff33c86a44ecad0866ea3d9226b834bb920c928f14fb7fb96ddeb46f93a8f2af54ddcf7e438488c09fcd0af14db34f7a9e09
    HEAD_REF master
)

if (VCPKG_TARGET_ARCHITECTURE MATCHES "x86")
    set(BUILD_ARCH "Win32")
    set(OUTPUT_DIR "Windows(x86)")
elseif (VCPKG_TARGET_ARCHITECTURE MATCHES "x64")
    set(BUILD_ARCH "x64")
    set(OUTPUT_DIR "Windows(x64)")
else()
    message(FATAL_ERROR "Unsupported architecture: ${VCPKG_TARGET_ARCHITECTURE}")
endif()

# List depending libraries before build
# file(GLOB_RECURSE LIBS ${SOURCE_PATH}/Siv3D/lib/${OUTPUT_DIR}/*.lib)

vcpkg_build_msbuild(
    PROJECT_PATH ${SOURCE_PATH}/MSVC/Siv3D.vcxproj
    PLATFORM ${BUILD_ARCH}
    OPTIONS /p:ForceImportBeforeCppTargets=${VCPKG_ROOT_DIR}/scripts/buildsystems/msbuild/vcpkg.targets
    OPTIONS_DEBUG /p:OutDir=${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/
    OPTIONS_RELEASE /p:OutDir=${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/
    OPTIONS /VERBOSITY:Diagnostic /DETAILEDSUMMARY
)

# Handle headers
file(COPY ${SOURCE_PATH}/Siv3D/include/Siv3D.hpp DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(COPY ${SOURCE_PATH}/Siv3D/include/HamFramework.hpp DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(COPY ${SOURCE_PATH}/Siv3D/include/HamFramework DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(COPY ${SOURCE_PATH}/Siv3D/include/Siv3D DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(COPY ${SOURCE_PATH}/Siv3D/include/ThirdParty DESTINATION ${CURRENT_PACKAGES_DIR}/include)

# Handle libraries
set(LIBRARY_OUT_DIRECTORY ${CURRENT_PACKAGES_DIR}/lib/Siv3D)
set(LIBRARY_DEBUG_OUT_DIRECTORY ${CURRENT_PACKAGES_DIR}/debug/lib/Siv3D)
file(MAKE_DIRECTORY ${LIBRARY_OUT_DIRECTORY})
file(MAKE_DIRECTORY ${LIBRARY_DEBUG_OUT_DIRECTORY})

file(INSTALL ${SOURCE_PATH}/Siv3D/lib/${OUTPUT_DIR}/ DESTINATION ${LIBRARY_DEBUG_OUT_DIRECTORY} FILES_MATCHING PATTERN "*d.lib")
file(INSTALL ${SOURCE_PATH}/Siv3D/lib/${OUTPUT_DIR}/ DESTINATION ${LIBRARY_OUT_DIRECTORY} FILES_MATCHING PATTERN "*.lib" PATTERN "*d.lib" EXCLUDE)

#foreach(LIB IN LISTS LIBS)
#    if (${LIB} MATCHES "d.lib")
#        file(INSTALL ${LIB} DESTINATION ${LIBRARY_DEBUG_OUT_DIRECTORY})
#    else()
#        file(INSTALL ${LIB} DESTINATION ${LIBRARY_OUT_DIRECTORY})
#    endif()
#endforeach()

file(INSTALL ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/Siv3D.lib DESTINATION ${LIBRARY_OUT_DIRECTORY})
file(INSTALL ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/Siv3D_d.lib DESTINATION ${LIBRARY_DEBUG_OUT_DIRECTORY})

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/opensiv3d RENAME copyright)

# Copy pdb
vcpkg_copy_pdbs()

message(STATUS "This package use extra library.\nYou should check the what library is in the ThirdParty directory.")
message(STATUS "Installing done")
