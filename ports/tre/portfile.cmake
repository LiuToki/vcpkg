include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO laurikari/tre
    REF 6fb7206b935b35814c5078c20046dbe065435363
    SHA512 f1d664719eab23b665d71e34ca3d11f8ba49da23ff20dc28f46d4ce30fe155c12208ba7fd212dbeb20a7037e069909f0c2120ce1fc01074656399805e3289a90
    HEAD_REF master
)

file(READ ${SOURCE_PATH}/win32/config.h CONFIG_H)
string(REPLACE "#define snprintf sprintf_s" "" CONFIG_H ${CONFIG_H})
file(WRITE ${SOURCE_PATH}/win32/config.h "${CONFIG_H}")

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/tre RENAME copyright)
