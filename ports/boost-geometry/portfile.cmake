# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/geometry
    REF boost-1.66.0
    SHA512 05f983d9258ddc663139a46ecb2f8a14988ad74fcc623af713bc486de2c9241896ca5f6a85d47cd02911f5f1f2f5acc439bb6f45ae9ef13667a30d27d9b5c123
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
