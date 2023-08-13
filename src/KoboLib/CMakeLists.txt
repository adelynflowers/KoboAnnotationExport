
find_package(GTest CONFIG REQUIRED)
# Lib setup
add_library(
    KoboLib STATIC src/koboDB.cpp
)

target_link_libraries(KoboLib
    PUBLIC
    unofficial::sqlite3::sqlite3
    SQLiteCpp
)

target_include_directories(KoboLib PUBLIC headers)

# TESTS

add_executable(
  KoboDB_test
  tests/koboDB_test.cpp
)
target_link_libraries(
  KoboDB_test
  PRIVATE
  GTest::gtest_main
  KoboLib
)

#gtest_discover_tests(KoboDB_test)