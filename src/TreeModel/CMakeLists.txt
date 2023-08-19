add_library(TreeModel treeModel.cpp treeItem.cpp)

set_target_properties(TreeModel PROPERTIES AUTOMOC ON)
target_include_directories(TreeModel PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(
    TreeModel PRIVATE 
    Qt6::Core 
    Qt6::Gui 
    Qt6::Quick 
)

qt_add_library(TreeModelLib STATIC)

set_target_properties(TreeModelLib PROPERTIES AUTOMOC ON)
target_link_libraries(
    TreeModelLib PRIVATE 
    Qt6::Core 
    Qt6::Gui 
    Qt6::Quick 
    TreeModel
)

qt_add_qml_module(TreeModelLib 
    URI TreeModelLib 
    OUTPUT_DIRECTORY TreeModelLib
    VERSION 1.0
    SOURCES 
    derivedExample.h derivedExample.cpp
)