#include "headers/bookModel.h"
#include <QRegularExpression>
#include <QDate>

// Member initialization constructor
QAnnotation::QAnnotation(int &row, QString &title, QString &text, QDate &date, int &color, QString &notes) : rowIndex{row}, title{title}, text{text}, date{date}, color{color}, notes{notes}
{
}

// Initialize object with roles. Set off timer for
// device searching.
BookModel::BookModel(QObject *parent)
    : QAbstractListModel(parent)
{
    // initialize custom roles that map to annotations
    rolenames[TitleRole] = "title";
    rolenames[TextRole] = "text";
    rolenames[DateRole] = "date";
    rolenames[ColorRole] = "highlightColor";
    rolenames[NotesRole] = "notes";

    QString title = "Wuthering Heights";
    int row = 0;
    QString text = "Heathcliff was a bastard";
    QDate lastModified(2023, 7, 1);
    int color = 1;
    QString notes = "Wow what a good book, jk it sucked";
    model.emplaceBack(row, title, text, lastModified, color, notes);
    // put model behind proxy model
    proxyModel.setSourceModel(this);
    // proxyModel.setFilterRole(TextRole);
    // proxyModel.setSortRole(TitleRole);
}

// Push state changes to DB
BookModel::~BookModel()
{
    // updateRows();
}

// Return the number of row in the model
int BookModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    // return our model count
    return model.count();
}

// Get model data at an index
QVariant BookModel::data(const QModelIndex &index, int role) const
{
    // the index returns the requested row and column information.
    // we ignore the column and only use the row information
    int row = index.row();

    // boundary check for the row
    if (row < 0 || row >= model.count())
    {
        return QVariant();
    }

    // A model can return data for different roles.
    // The default role is the display role.
    // it can be accesses in QML with "model.display"
    switch (role)
    {
    case TitleRole:
        // Return the color name for the particular row
        // Qt automatically converts it to the QVariant type
        return model.at(row).title;
    case TextRole:
        return model.at(row).text;
    case DateRole:
        return model.at(row).date;
    case ColorRole:
        return model.at(row).color;
    case NotesRole:
        return model.at(row).notes;
    default:
        return QVariant();
    }
}

// Link between qml properties and role names
QHash<int, QByteArray> BookModel::roleNames() const
{
    return this->rolenames;
}

// Open a db with KoboDB and add its data
// to the model
bool BookModel::openKoboDB(QString loc)
{
    // initialize model with kobo DB annotations
    auto dbLoc = loc.toStdString();
    try
    {

        auto kdb = KoboDB::openKoboDB(dbLoc);
        auto annotations = kdb.extractAnnotations();
        // TODO: prevent copy of vector
        writeToApplicationDB(annotations);
        selectAll();
        return true;
    }
    catch (SQLite::Exception &ex)
    {
        std::cerr << "Failed to open DB " << dbLoc << ": " << ex.what() << std::endl;
        return false;
    }
}

// Select * from app DB and load into
// model
void BookModel::executeSelectQuery(std::string query)
{
    // TODO: Do this on BG thread
    qDebug() << "Executing select query";
    if (!appDB)
    {
        return;
    }

    SQLite::Statement stmt(*appDB, query);

    model.clear();
    QString currentTitle = "";
    layoutAboutToBeChanged();
    while (stmt.executeStep())
    {

        // TODO: Figure out emplace back for QAnnotation
        auto title = QString::fromStdString(stmt.getColumn(0).getString());
        // layoutAboutToBeChanged();
        auto text = QString::fromStdString(stmt.getColumn(1).getString()).trimmed();
        auto lastModifiedStr = QString::fromStdString(stmt.getColumn(2).getString());
        auto lastModified = QDate::fromString(lastModifiedStr, Qt::ISODate);
        auto color = stmt.getColumn(3).getInt();
        auto rowId = stmt.getColumn(4).getInt();
        auto notes = QString::fromStdString(stmt.getColumn(5).getString());
        model.emplaceBack(rowId, title, text, lastModified, color, notes);
    }
    proxyModel.customSort(true, true, Qt::AscendingOrder);
    layoutChanged();
}

// Selects all rows from app DB and pushes to model
void BookModel::selectAll()
{
    executeSelectQuery(
        "SELECT title, bookmarkText, dateModified, kaeColor, annotationId, kaeNotes FROM annotations ORDER BY title, dateModified;");
}

// Filters annotations on a query string
void BookModel::searchAnnotations(QString query)
{
    proxyModel.setFilterRegularExpression(QRegularExpression(query, QRegularExpression::CaseInsensitiveOption));
}

// Open the application DB and assign it to appDB
bool BookModel::openApplicationDB(QString loc)
{
    // try
    // {
    //     qDebug() << "Opening application DB located at " << loc;
    //     appDB = std::make_unique<SQLite::Database>(loc.toStdString(), SQLite::OPEN_READWRITE);
    //     return true;
    // }
    // catch (SQLite::Exception ex)
    // {
    //     qDebug() << "Failed to open application DB:" << ex.what();
    //     return false;
    // }
}

// Write a list of annotations to the app db
void BookModel::writeToApplicationDB(std::vector<KoboDB::Annotation> annotations)
{
    if (appDB)
    {
        qDebug() << "annotations reportedly exists: " << appDB->tableExists("annotations");
        SQLite::Transaction transaction(*appDB);
        SQLite::Statement query{
            *appDB,
            "INSERT OR IGNORE INTO annotations ("
            "volumeId,bookmarkText,"
            "bookmarkAnnotation,dateCreated,"
            "dateModified,bookTitle,"
            "title,attribution)"
            " VALUES (?,?,?,?,?,?,?,?)"};
        for (const auto &a : annotations)
        {
            query.bind(1, a.volumeId);
            query.bind(2, a.text);
            query.bind(3, a.annotation);
            query.bind(4, a.dateCreated);
            query.bind(5, a.dateModified);
            query.bind(6, a.bookTitle);
            query.bind(7, a.title);
            query.bind(8, a.attribution);
            query.exec();
            query.reset();
        }

        transaction.commit();
    }
    else
    {
        qDebug() << "Error: application DB has no annotations table";
    }
}

// Update changed rows in the app db
void BookModel::updateRows()
{
    SQLite::Transaction transaction(*appDB);
    SQLite::Statement query{*appDB,
                            "UPDATE annotations SET kaeColor = ?, kaeNotes = ? WHERE annotations.annotationId = ?"};
    for (auto i = changedAnnotations.cbegin(), end = changedAnnotations.cend(); i != end; ++i)
    {
        auto annotation = model[i.key()];
        qDebug() << "updating row " << annotation.rowIndex;
        query.bind(1, annotation.color);
        query.bind(2, annotation.notes.toStdString());
        query.bind(3, annotation.rowIndex);
        query.exec();
        query.reset();
    }
    transaction.commit();
}

// Sort rows by date
void BookModel::sortByDate(bool descending)
{
    Qt::SortOrder order;
    if (!descending)
        order = Qt::SortOrder::AscendingOrder;
    else
        order = Qt::SortOrder::DescendingOrder;
    layoutAboutToBeChanged();
    proxyModel.customSort(true, false, order);
    layoutChanged();
}

// Toggle the filter on a color
void BookModel::toggleFilterOnColor(int weight)
{
    proxyModel.toggleColorFilter(weight);
}

// Add a color to an annotation
void BookModel::addAnnotationColor(int row, short color)
{
    layoutAboutToBeChanged();
    auto modelIdx = proxyModel.mapToSource(proxyModel.index(row, 0)).row();
    model[modelIdx].color *= color;
    changedAnnotations[modelIdx] = true;
    layoutChanged();
}

// Remove a color from an annotation
void BookModel::removeAnnotationColor(int row, short color)
{
    layoutAboutToBeChanged();
    auto modelIdx = proxyModel.mapToSource(proxyModel.index(row, 0)).row();
    model[modelIdx].color /= color;
    changedAnnotations[modelIdx] = true;
    layoutChanged();
}

// Updates the note string on an annotation
void BookModel::updateNoteString(int row, QString noteString)
{
    layoutAboutToBeChanged();
    auto modelIdx = proxyModel.mapToSource(proxyModel.index(row, 0)).row();
    model[modelIdx].notes = noteString;
    changedAnnotations[modelIdx] = true;
    layoutChanged();
}
