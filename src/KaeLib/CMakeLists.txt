qt_add_library(KaeLib STATIC)

set_target_properties(KaeLib PROPERTIES AUTOMOC ON)
target_link_libraries(
    KaeLib PRIVATE 
    Qt6::Core 
    Qt6::Gui 
    Qt6::Quick 
)

qt_add_qml_module(KaeLib 
    URI KaeLib 
    OUTPUT_DIRECTORY src/KaeLib
    VERSION 1.0
    SOURCES 
    kaeLib.cpp kaeLib.h
)
