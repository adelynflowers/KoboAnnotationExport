# Newest version to satisfy vcpkg's sqlite3
cmake_minimum_required(VERSION 3.27.1)

project(KoboAnnotationExport VERSION 0.1 LANGUAGES CXX)

# Testing with GTest
enable_testing()
include(GoogleTest)
list(APPEND CMAKE_PREFIX_PATH "/home/adelynflowers/Qt/6.5.2/gcc_64")

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Core)
find_package(unofficial-sqlite3 CONFIG REQUIRED)
find_package(SQLiteCpp CONFIG REQUIRED)

# Qt setup
qt_standard_project_setup(REQUIRES 6.5)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC on)
set(AUTOMOC_PATH_PREFIX on)

# Packages

# Qt executable setup
qt_add_executable(kae
    main.cpp
)

# qt_add_qml_module(kae 
#     VERSION 1.0
#     URI FirstScreen 
#     QML_FILES src/FirstScreen/qml/Main.qml 
#     SOURCES src/FirstScreen/headers/newClass.h
# )

qt_add_qml_module(kae 
    VERSION 1.0
    URI MainView 
    QML_FILES 
        src/qml/Main.qml 
        src/qml/TreeTest.qml
)



# SubModules after Qt setup

## KoboLib
add_subdirectory(src/KoboLib)

## Book model
#add_subdirectory(src/BookModel)

## KaeLib
add_subdirectory(src/KaeLib)

## Tree model
add_subdirectory(src/TreeModel)

## Nested List Model
add_subdirectory(src/DoubleList)

# Link libraries
target_link_libraries(kae
    PRIVATE 
    Qt6::Quick 
    Qt6::Qml
    KoboLib
    #BookListLibplugin
    KaeLibplugin
    TreeModelLibplugin
    NestedListModelplugin
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

