qt_add_library(BookModelLib STATIC)

set_target_properties(BookModelLib PROPERTIES AUTOMOC ON)
target_include_directories(BookModelLib PUBLIC ${CMAKE_CURRENT_LIST_DIR}/headers)
target_link_libraries(
        BookModelLib PRIVATE
        Qt6::Core
        Qt6::Gui
        Qt6::Quick
        KoboLib
)

qt_add_qml_module(BookModelLib
        URI BookModelLib
        OUTPUT_DIRECTORY BookModelLib
        VERSION 1.0
        SOURCES
        src/bookModel.cpp headers/bookModel.h
        src/proxyModel.cpp headers/proxyModel.h
)

qt_add_library(BookListLib STATIC)

qt_add_qml_module(BookListLib
        URI BookListLib
        VERSION 1.0
        OUTPUT_DIRECTORY BookListLib
        QML_FILES
        qml/BookListView.qml
        qml/BookModelDelegate.qml
        qml/BookSectionDelegate.qml
        qml/RoundHoverButton.qml
        qml/NotesPopup.qml
)

target_link_libraries(
        BookListLib PRIVATE
        Qt6::Quick
        Qt6::Core
        Qt6::Gui
        BookModelLib
)