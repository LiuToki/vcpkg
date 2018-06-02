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
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/Cubism3SDKforNative-beta3)
vcpkg_download_distfile(ARCHIVE
    URLS "https://s3-ap-northeast-1.amazonaws.com/cubism3.live2d.com/sdk/Cubism3SDKforNative-beta3.zip"
    FILENAME "Cubism3SDKforNative-beta3.zip"
    SHA512 e985f52e661abcc125a19b203c00e71b79f10dc250d977fc6088f67f8b90a827327a7737949cbc82ca652007d43b616f17d4e2531471743a2cf6d02bf9b8075c
)
vcpkg_extract_source_archive(${ARCHIVE})

if (VCPKG_TARGET_ARCHITECTURE MATCHES "x86")
    set(BUILD_ARCH "x86")
elseif (VCPKG_TARGET_ARCHITECTURE MATCHES "x64")
    set(BUILD_ARCH "x86_64")
else()
    message(FATAL_ERROR "Unsupported architecture: ${VCPKG_TARGET_ARCHITECTURE}")
endif()

# Handle headers
file(INSTALL ${SOURCE_PATH}/Core/include/Live2DCubismCore.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)

# Handle libraries
set(LIBRARY_ROOT_PATH ${SOURCE_PATH}/Core/lib/windows)
set(LIBRARY_OUT_DIRECTORY ${CURRENT_PACKAGES_DIR}/lib)
set(LIBRARY_DEBUG_OUT_DIRECTORY ${CURRENT_PACKAGES_DIR}/debug/lib)
# Debug
if (VCPKG_LIBRARY_LINKAGE MATCHES "static")
    file(INSTALL ${LIBRARY_ROOT_PATH}/${BUILD_ARCH}/140/Live2DCubismCore_MTd.lib DESTINATION ${LIBRARY_DEBUG_OUT_DIRECTORY})
elseif (VCPKG_TARGET_ARCHITECTURE MATCHES "dynamic")
    file(INSTALL ${LIBRARY_ROOT_PATH}/${BUILD_ARCH}/140/Live2DCubismCore_MDd.lib DESTINATION ${LIBRARY_DEBUG_OUT_DIRECTORY})
endif()
# Release
if (VCPKG_LIBRARY_LINKAGE MATCHES "static")
    file(INSTALL ${LIBRARY_ROOT_PATH}/${BUILD_ARCH}/140/Live2DCubismCore_MT.lib DESTINATION ${LIBRARY_OUT_DIRECTORY})
elseif (VCPKG_TARGET_ARCHITECTURE MATCHES "dynamic")
    file(INSTALL ${LIBRARY_ROOT_PATH}/${BUILD_ARCH}/140/Live2DCubismCore_MD.lib DESTINATION ${LIBRARY_OUT_DIRECTORY})
endif()

# Handle copyright
file(INSTALL ${SOURCE_PATH}/Core/License.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/live2d RENAME copyright)
