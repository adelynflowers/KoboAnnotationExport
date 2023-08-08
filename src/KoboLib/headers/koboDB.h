#ifndef KOBODB_H
#define KOBODB_H
#include <memory>
#include <SQLiteCpp/SQLiteCpp.h>
#include <iostream>
#include <vector>
namespace KoboDB
{

  struct AnnotatedBook
  {
    std::string volumeId;
    std::string bookTitle;
    std::string title;
    std::string attribution;
  };

  struct Annotation
  {
    std::string volumeId;
    std::string text;
    std::string annotation;
    std::string extraAnnotationData;
    std::string dateCreated;
    std::string dateModified;
    std::string bookTitle;
    std::string title;
    std::string attribution;
  };

  /**
   * @brief A class for finding and extracting highlights from a kobo
   database.
   *
   */
  class KoboDB
  {
  public:
    static const char *getDBLoc();

    void setDB(SQLite::Database *db);

    std::vector<Annotation> extractAnnotations();

    std::vector<AnnotatedBook> extractAnnotatedBooks();

  private:
    std::unique_ptr<SQLite::Database> db;
  };

  KoboDB openKoboDB(std::string);
  void displayQuery(SQLite::Statement *);

}
#endif // KOBODB_H