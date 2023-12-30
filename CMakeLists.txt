cmake_minimum_required(VERSION 3.24.2)

set(WIN_DEBUG 0)

#list(APPEND VCPKG_INSTALL_OPTIONS "--debug")
#list(APPEND VCPKG_INSTALL_OPTIONS "--debug-env")
if(NOT DEFINED CMAKE_TOOLCHAIN_FILE)
  set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_LIST_DIR}/vcpkg/scripts/buildsystems/vcpkg.cmake)
elseif(DEFINED CMAKE_TOOLCHAIN_FILE AND NOT CMAKE_TOOLCHAIN_FILE MATCHES ".+/vcpkg/scripts/buildsystems/vcpkg.cmake$")
  message(STATUS "CMAKE_TOOLCHAIN_FILE is already set to '${CMAKE_TOOLCHAIN_FILE}', replacing it with the vcpkg one and set VCPKG_CHAINLOAD_TOOLCHAIN_FILE to original CMAKE_TOOLCHAIN_FILE")
  set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE ${CMAKE_TOOLCHAIN_FILE})
  set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_LIST_DIR}/vcpkg/scripts/buildsystems/vcpkg.cmake)
else()
  message(STATUS "CMAKE_TOOLCHAIN_FILE is already set to '${CMAKE_TOOLCHAIN_FILE}'")
  message(STATUS "VCPKG_CHAINLOAD_TOOLCHAIN_FILE is already set to '${VCPKG_CHAINLOAD_TOOLCHAIN_FILE}'")
endif()

project(KoboAnnotationExport VERSION 0.1 LANGUAGES CXX)

# Packages
find_package(Qt6 6.6 REQUIRED COMPONENTS Quick Core Qml)
find_package(unofficial-sqlite3 CONFIG REQUIRED)
find_package(SQLiteCpp CONFIG REQUIRED)

# Qt setup
qt_standard_project_setup(REQUIRES 6.6)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC on)
set(AUTOMOC_PATH_PREFIX on)

if(WIN32)
  # Qt executable setup
  qt_add_executable(kae
    main.cpp
    ${CMAKE_CURRENT_LIST_DIR}/windows/kae.rc
  )
elseif(APPLE)
  set(MACOSX_BUNDLE_ICON_FILE kae.icns)
  set(kae_ICON ${CMAKE_CURRENT_LIST_DIR}/macos/kae.icns)
  set_source_files_properties(${kae_ICON} PROPERTIES
    MACOSX_PACKAGE_LOCATION "Resources")

  qt_add_executable(kae
    main.cpp
    ${kae_ICON}
  )
else()
  qt_add_executable(kae
    main.cpp
  )
endif()

qt_add_qml_module(kae
  VERSION 1.0
  URI MainView
  QML_FILES
  src/qml/Main.qml
  src/qml/KaePalette.qml
  src/qml/Toast.qml
  src/qml/ToastManager.qml
  src/qml/KaeDarkPalette.qml
)

# SubModules after Qt setup

# # KoboLib
add_subdirectory(src/KoboLib)

# # Book model
add_subdirectory(src/BookModel)

# # KaeLib
add_subdirectory(src/KaeLib)

# Link libraries
target_link_libraries(kae
  PUBLIC
  Qt6::Quick
  Qt6::Qml
  KoboLib
  BookListLibplugin
  KaeLib
)

qt_add_resources(kae "font_files"
  PREFIX "/"
  FILES
  fonts/fontello.ttf
)

set_target_properties(kae PROPERTIES
  MACOSX_BUNDLE_GUI_IDENTIFIER io.github.adelynflowers.Kae
  MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
  MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
  MACOSX_BUNDLE TRUE
  WIN32_EXECUTABLE !${WIN_DEBUG}
)

if(WIN32)
  install(
    TARGETS kae
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
  )
elseif(APPLE)
  install(
    TARGETS kae
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    BUNDLE DESTINATION .
  )
endif()

if(WIN32)
  install(FILES ${PROJECT_BINARY_DIR}/libkae.dll.a DESTINATION bin)
  set(CPACK_GENERATOR WIX)
  set(CPACK_WIX_PROGRAM_MENU_FOLDER .)
  set(CPACK_PACKAGE_EXECUTABLES "kae" "kae")
  set(CPACK_PACKAGE_ICON ${CMAKE_CURRENT_LIST_DIR}/windows/kae.ico)
  set(CPACK_WIX_UPGRADE_GUID "ad2a08f1-5dea-4162-aefc-38bb91c4f5e9")
elseif(APPLE)
  set(CPACK_GENERATOR DragNDrop)
  set(CPACK_DMG_VOLUME_NAME "Kae")
endif()

qt_generate_deploy_qml_app_script(
  TARGET kae
  FILENAME_VARIABLE deploy_script

  # NO_UNSUPPORTED_PLATFORM_ERROR
)
install(SCRIPT ${deploy_script})

set(CPACK_PACKAGE_NAME "kae")
set(CPACK_PACKAGE_VENDOR "Adelyn Flowers (adelynflowers.github.io)")
set(CPACK_PACKAGE_DESCRIPTION "A utility for extracting and managing Kobo highlights")
set(CPACK_PACKAGE_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/deploy)
set(CPACK_PACKAGE_HOMEPAGE_URL "https://www.github.com/adelynflowers/KoboAnnotationExportTool")
set(CPACK_RESOURCE_FILE_LICENSE ${CMAKE_CURRENT_LIST_DIR}/LICENSE.txt)
set(CPACK_PACKAGE_INSTALL_DIRECTORY "kae")
include(CPack)

# Set the CPACK and WIX variables here.
