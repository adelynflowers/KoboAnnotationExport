find_package(unofficial-sqlite3 CONFIG REQUIRED)
find_package(SQLiteCpp CONFIG REQUIRED)

add_library(KaeLib STATIC kaeLib.cpp)
target_include_directories(KaeLib PUBLIC ${CMAKE_CURRENT_LIST_DIR})
set_target_properties(KaeLib PROPERTIES AUTOMOC ON)
target_link_libraries(
    KaeLib PRIVATE
    Qt6::Core 
    Qt6::Gui 
    Qt6::Quick
    unofficial::sqlite3::sqlite3 
    SQLiteCpp
)
