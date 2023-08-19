qt_add_library(NestedListModel STATIC)

set_target_properties(NestedListModel PROPERTIES AUTOMOC ON)
target_link_libraries(
    NestedListModel PRIVATE 
    Qt6::Core 
    Qt6::Gui 
    Qt6::Quick 
)

qt_add_qml_module( 
    NestedListModel 
    URI com.kae.NestedListModelLib
    VERSION 1.0
    SOURCES 
    innerList.cpp outerList.cpp 
    innerList.h outerList.h
)