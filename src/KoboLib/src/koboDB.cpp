#include <koboDB.h>
namespace KoboDB
{
    /***
     * Dummy helper
     */
    const char *KoboDB::getDBLoc()
    {
        std::string a = "ABC123";
        SQLite::Database(a.c_str());
        return a.c_str();
    }

    void KoboDB::setDB(SQLite::Database *db)
    {
        this->db.reset(db);
    }

    KoboDB openKoboDB(std::string filename)
    {
        auto db = new SQLite::Database(filename);
        KoboDB kdb;
        kdb.setDB(db);
        return kdb;
    }

    void displayQuery(SQLite::Statement *stmt)
    {
        while (stmt->executeStep())
        {
            int columnCount = stmt->getColumnCount();
            for (int i = 0; i < columnCount; i++)
            {
                std::cout << stmt->getColumn(i) << "\t";
            }
            std::cout << std::endl;
        }
    }

    std::vector<AnnotatedBook> KoboDB::extractAnnotatedBooks()
    {
        const char *query = "SELECT DISTINCT "
                            "Bookmark.VolumeID, "
                            "content.BookTitle, "
                            "content.Title, "
                            "content.Attribution "
                            "FROM Bookmark INNER JOIN content "
                            "ON Bookmark.VolumeID = content.ContentID "
                            "ORDER BY content.Title;";
        SQLite::Statement stmt((*this->db), query);
        // displayQuery(&stmt);
        std::vector<AnnotatedBook> books;
        while (stmt.executeStep())
        {
            auto volumeId = stmt.getColumn(0).getString();
            auto bookTitle = stmt.getColumn(1).getString();
            auto title = stmt.getColumn(2).getString();
            auto attrib = stmt.getColumn(3).getString();
            AnnotatedBook ab{.volumeId = volumeId, .bookTitle = bookTitle, .title = title, .attribution = attrib};
            books.push_back(ab);
        }
        return books;
    }

    std::vector<Annotation> KoboDB::extractAnnotations()
    {
        const char *query = "SELECT "
                            "Bookmark.VolumeID, "
                            "Bookmark.Text, "
                            "Bookmark.Annotation, "
                            "Bookmark.ExtraAnnotationData, "
                            "Bookmark.DateCreated, "
                            "Bookmark.DateModified, "
                            "content.BookTitle, "
                            "content.Title, "
                            "content.Attribution "
                            "FROM Bookmark INNER JOIN content "
                            "ON Bookmark.VolumeID = content.ContentID;";
        SQLite::Statement stmt((*this->db), query);
        std::vector<Annotation> annotations;
        while (stmt.executeStep())
        {
            auto volumeId = stmt.getColumn(0).getString();
            auto text = stmt.getColumn(1).getString();
            auto annotation = stmt.getColumn(2).getString();
            auto extraAnnotationData = stmt.getColumn(3).getString();
            auto dateCreated = stmt.getColumn(4).getString();
            auto dateModified = stmt.getColumn(5).getString();
            auto bookTitle = stmt.getColumn(6).getString();
            auto title = stmt.getColumn(7).getString();
            auto attribution = stmt.getColumn(8).getString();
            Annotation a{
                .volumeId = volumeId,
                .text = text,
                .annotation = annotation,
                .dateCreated = dateCreated,
                .dateModified = dateModified,
                .bookTitle = bookTitle,
                .title = title,
                .attribution = attribution};
            annotations.push_back(a);
        }
        return annotations;
    }
}