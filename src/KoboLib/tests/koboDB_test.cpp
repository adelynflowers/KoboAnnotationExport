#include <gtest/gtest.h>
#include <koboDB.h>
#define DB_LOC "/home/adelynflowers/dev/qt-quick-project/src/KoboLib/data/KoboReader.sqlite"
TEST(KoboSqlTests, OpenDBFailure)
{
    EXPECT_THROW(KoboDB::openKoboDB("ABC123"), SQLite::Exception);
    EXPECT_THROW(KoboDB::openKoboDB("data/not_a_rel_file.db"), SQLite::Exception);
    EXPECT_THROW(KoboDB::openKoboDB("abc123"), SQLite::Exception);
}
TEST(KoboSqlTests, OpenDBSuccess)
{
    EXPECT_NO_THROW(KoboDB::openKoboDB(DB_LOC));
    EXPECT_NO_THROW(KoboDB::openKoboDB("/media/adelynflowers/KOBOeReader/"));
}
TEST(KoboSqlTests, ExtractAnnotations)
{
    auto kdb = KoboDB::openKoboDB(DB_LOC);
    auto annotations = kdb.extractAnnotations();
    for (auto a : annotations)
    {
        std::cout << a.text << std::endl;
    }
    EXPECT_NO_THROW(kdb.extractAnnotatedBooks());
    EXPECT_NO_THROW(kdb.extractAnnotations());
}
