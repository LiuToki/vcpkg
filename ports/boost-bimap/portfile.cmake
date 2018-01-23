# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/bimap
    REF boost-1.66.0
    SHA512 f0784a2fd2be60b404d8a3bb43fa4685ab75a17a18e9e9fb0a8e8d1df18323ad02ad12720f5cfb310c93a33fd3bdec09d8ac92cbc4ff875f9ff4c3a6263d4f8b
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
