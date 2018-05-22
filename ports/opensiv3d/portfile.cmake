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
    REF 88697303597b94bdcdaa3475726310d2d35cfb01
    SHA512 d88b209795c10f6f65819748bf6d4f47c6a91fd401ea88b8deb0db6a478dda0d796e3c44e92c3f2a0b76c68b73d4832f0ecd9e0bc56e694bf37dbb69570028a1
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
file(GLOB_RECURSE LIBS ${SOURCE_PATH}/Siv3D/lib/${OUTPUT_DIR}/*.lib)

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

foreach(LIB IN LISTS LIBS)
    if (${LIB} MATCHES "d.lib")
        file(INSTALL ${LIB} DESTINATION ${LIBRARY_DEBUG_OUT_DIRECTORY})
    else()
        file(INSTALL ${LIB} DESTINATION ${LIBRARY_OUT_DIRECTORY})
    endif()
endforeach()

file(INSTALL ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/Siv3D.lib DESTINATION ${LIBRARY_OUT_DIRECTORY})
file(INSTALL ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/Siv3D_d.lib DESTINATION ${LIBRARY_DEBUG_OUT_DIRECTORY})

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/siv3d RENAME copyright)

# Copy pdb
vcpkg_copy_pdbs()

message(STATUS "Installing done")
