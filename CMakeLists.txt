# Newest version to satisfy vcpkg's sqlite3
#set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_LIST_DIR}/vcpkg/scripts/buildsystems/vcpkg.cmake)
cmake_minimum_required(VERSION 3.24.2)

if(NOT DEFINED CMAKE_TOOLCHAIN_FILE)
  set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_LIST_DIR}/vcpkg/scripts/buildsystems/vcpkg.cmake)
  # list(APPEND CMAKE_PREFIX_PATH "~/Qt/6.5.2/gcc_64")
  list(APPEND CMAKE_PREFIX_PATH "/home/adelynflowers/Qt/6.5.2/wasm_multithread")
elseif(DEFINED CMAKE_TOOLCHAIN_FILE AND NOT CMAKE_TOOLCHAIN_FILE MATCHES ".+/vcpkg/scripts/buildsystems/vcpkg.cmake$")
  message(STATUS "CMAKE_TOOLCHAIN_FILE is already set to '${CMAKE_TOOLCHAIN_FILE}', replace it with the vcpkg one and set VCPKG_CHAINLOAD_TOOLCHAIN_FILE to original CMAKE_TOOLCHAIN_FILE")
  set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE ${CMAKE_TOOLCHAIN_FILE})
  set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_LIST_DIR}/vcpkg/scripts/buildsystems/vcpkg.cmake)
else()
  message(STATUS "CMAKE_TOOLCHAIN_FILE is already set to '${CMAKE_TOOLCHAIN_FILE}'")
  message(STATUS "VCPKG_CHAINLOAD_TOOLCHAIN_FILE is already set to '${VCPKG_CHAINLOAD_TOOLCHAIN_FILE}'")
endif()

project(KoboAnnotationExport VERSION 0.1 LANGUAGES CXX)
# Testing with GTest
# enable_testing()
# include(GoogleTest)

# Packages
find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Core)
find_package(unofficial-sqlite3 CONFIG REQUIRED)
find_package(SQLiteCpp CONFIG REQUIRED)

# Qt setup
qt_standard_project_setup(REQUIRES 6.5)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC on)
set(AUTOMOC_PATH_PREFIX on)
add_compile_options(-fno-exceptions)


# Qt executable setup
qt_add_executable(kae
    main.cpp
)

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

## KoboLib
add_subdirectory(src/KoboLib)

## Book model
add_subdirectory(src/BookModel)

## KaeLib
add_subdirectory(src/KaeLib)

# Link libraries
target_link_libraries(kae
    PRIVATE 
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
# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(kae PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appKoboAnnotationExport
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)




include(GNUInstallDirs)
install(TARGETS kae
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

