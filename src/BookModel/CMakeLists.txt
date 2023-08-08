qt_add_library(BookModelLib STATIC)

set_target_properties(BookModelLib PROPERTIES AUTOMOC ON)
target_link_libraries(
    BookModelLib PRIVATE 
    Qt6::Core 
    Qt6::Gui 
    Qt6::Quick 
    KoboLib
)

qt_add_qml_module(BookModelLib
    URI BookModelLib
    VERSION 1.0
    QML_FILES 
        BookListView.qml 
        BookModelDelegate.qml
    SOURCES 
        bookModel.cpp 
        bookModel.h 
)
