#ifndef BOOKMODEL_H
#define BOOKMODEL_H
/**
 * @file bookModel.h
 * @brief QML ListView model of kobo highlights
 */

#include <QtCore>
#include <QtQml/qqmlregistration.h>
#include "koboDB.h"
#include <memory>
#include "proxyModel.h"

/**
 * @brief A Qt-friendly container for annotation information.
 *
 * An object representing one annotation, which has a book
 * title and annotated text.
 */
struct QAnnotation
{
public:
    int rowIndex;
    QString title; // book title
    QString text;  // annotation text
    QDate date;    // last modified date
    int color;
    QString notes;

    QAnnotation(int &index, QString &title, QString &text, QDate &date, int &color, QString &notes);
};

/**
 * @brief A QML ListView model that holds annotations.
 *
 * BookModel can be used as a model of a QML list view,
 * and provides a number of QML invokable functions to
 * facilitate interacting with the list. Unless otherwise
 * stated actions are additive, e.g. opening a database
 * adds its content to the view rather than replacing it.
 *
 */
class BookModel : public QAbstractListModel
{
    Q_OBJECT

    QML_ELEMENT
public:
    /**
     * Role names for QML access
     */
    enum RoleNames
    {
        TitleRole = Qt::UserRole,
        TextRole,
        DateRole,
        ColorRole,
        NotesRole
    };

    /**
     * @brief Construct a new Book Model object.
     *
     * Role names and timer member are initialized. timer
     * ticks at intervals of 1s and is connected to the
     * searchDevices slot.
     *
     * @param parent parent, used by Qt
     */
    explicit BookModel(QObject *parent = nullptr);

    /**
     * @brief Destroy the Book Model object
     */
    ~BookModel();

    /**
     * @brief Returns the number of rows in the model.
     *
     * A virtual function needed by QML. Returns the count()
     * method of m_data.
     *
     * @param parent parent, used by Qt
     * @return int number of rows in m_data
     */
    virtual int rowCount(const QModelIndex &parent) const;

    /**
     * @brief Grab the data at an index.
     *
     * Uses RoleNames to provides access to annotation data.
     * TitleRole returns title, TextRole returns text. All other
     * rows return an empty QVariant.
     *
     * @param index index of data
     * @param role [Title|Text]Role for [title|text]
     * @return QVariant requested data or empty
     */
    virtual QVariant data(const QModelIndex &index, int role) const;

    /**
     * @brief Hash table for role names.
     *
     * "text" is assigned to TextRole, "title" is assigned
     * to TitleRole.
     *
     * @return QHash<int, QByteArray> Table with role names defined
     */
    virtual QHash<int, QByteArray> roleNames() const;

    /**
     * @brief Opens a database and adds the data to the model.
     *
     * The database must implement the schemas used by KoboLib.
     * KoboLib will be used to open the database and extract the
     * annotations, adding them to the model.
     *
     * @param dbLoc path to database
     * @return true if annotations were extracted successfully
     * @return false if failed to extract
     */
    Q_INVOKABLE bool openKoboDB(QString dbLoc);

    /**
     * @brief Opens the application DB and assigns it
     * to appDB.
     *
     * @param dbLoc path to database
     * @return true if opened successfully
     * @return false if not opened
     */
    Q_INVOKABLE bool openApplicationDB(QString dbLoc);

    /**
     * @brief Queries the application db
     * for all entries and adds them to the
     * model.
     *
     */
    Q_INVOKABLE void selectAll();

    /**
     * @brief Filters the annotations to
     * a subset that match the given query.
     *
     * @param query
     * @return Q_INVOKABLE
     */
    Q_INVOKABLE void searchAnnotations(QString query);

    /**
     * @brief Gets the proxy model which is the front-end for
     * the class.
     * @return the proxy model
     */
    Q_INVOKABLE QSortFilterProxyModel *getProxyModel()
    {
        return &proxyModel;
    }

    /**
     * @brief Adds a highlight color to an annotation
     * @param row row number in proxy model
     * @param color color weight
     */
    Q_INVOKABLE void addAnnotationColor(int row, short color);

    /**
     * @brief Removes a highlight color from an annotation
     * @param row row number in proxy model
     * @param color color weight
     */
    Q_INVOKABLE void removeAnnotationColor(int row, short color);

    /**
     * Sorts the model strictly by date
     * @param descending true if descending order
     */
    Q_INVOKABLE void sortByDate(bool descending);

    /**
     * Sorts the model strictly by title
     * @param descending true if descending order
     */
    Q_INVOKABLE void sortByTitle(bool descending);

    /**
     * @brief Toggles the filter on a highlight color
     * @param weight color weight
     */
    Q_INVOKABLE void toggleFilterOnColor(int weight);
    /**
     * @brief Updates the note string at a given index
     * @param row proxyModel row
     * @param noteString new note string
     */
    Q_INVOKABLE void updateNoteString(int row, QString noteString);

    /**
     * @brief Pushes changes made in UI to appDB
     */
    Q_INVOKABLE void updateRows();

    Q_INVOKABLE void exportAnnotations(QUrl location);

private:
    /**
     * @brief Writes a list of annotations from a Kobo DB to
     * the application DB.
     *
     * @param annotations vector of KoboDB Annotations
     */
    void writeToApplicationDB(std::vector<KoboDB::Annotation> annotations);

    /**
     * @brief Executes a select query
     * and updates the model with the results.
     *
     * Enforces the order that variables are declared
     * in the QAnnotation definition.
     *
     * @param query query to run
     */
    void executeSelectQuery(std::string query);

    // Annotation list
    QList<QAnnotation> model;

    // Role names hash table
    QHash<int, QByteArray> rolenames;

    // Application DB
    std::unique_ptr<SQLite::Database> appDB;

    // Proxy model
    BookProxyModel proxyModel;

    // Map of annotations that have state changes
    QHash<int, bool> changedAnnotations;
};

#endif // BOOKMODEL_H
