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

find_program(GIT git)
vcpkg_find_acquire_program(PYTHON2)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO cocos2d/cocos2d-x
    REF cocos2d-x-3.17.1
    SHA512 461f31dfb6ad194f618d12ede8671d57e7244ce7e39aac93bfaf9e6faf89fd5d4de7f5976e3fabfb93fbfc5b7bd4fd8ea255152eb9a01cd05b599c1a23acb4d8
    HEAD_REF master
)

vcpkg_execute_required_process(
    COMMAND ${PYTHON2} ${SOURCE_PATH}/download-deps.py
    WORKING_DIRECTORY SOURCE_PATH
    LOGNAME python-${TARGET_TRIPLET}-download-deps
)

vcpkg_execute_required_process(
    COMMAND ${GIT} submodule update --init
    WORKING_DIRECTORY SOURCE_PATH
    LOGNAME git-${TARGET_TRIPLET}-submodule-update
)

# Handle headers
file(INSTALL ${SOURCE_PATH}/cocos DESTINATION ${CURRENT_PACKAGES_DIR}/include/cocos2d-x)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/CONTRIBUTING.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/cocos2d-x RENAME copyright)

message(STATUS "If you use this library, please use following props.\n{include directory}\\cocos2d-x\\cocos2d-x\\cocos\\2d\\cocos2dx.props\n{include directory}\\cocos2d-x\\cocos2d-x\\cocos\\2d\\cocos2d_headers.props")
message(STATUS "Installing done")
