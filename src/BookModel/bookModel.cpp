#include "bookModel.h"
#define DB_LOC "/home/adelynflowers/dev/qt-quick-project/src/KoboLib/data/KoboReader.sqlite"
#include <QRegularExpression>
#include <QDate>

QAnnotation::QAnnotation(int &row, QString &title, QString &text, QString &date, int &color, QString &notes) : rowIndex{row},
                                                                                                               title{title},
                                                                                                               text{text},
                                                                                                               date{date},
                                                                                                               color{color},
                                                                                                               notes{notes}
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

    // put model behind proxy model
    proxyModel.setSourceModel(this);
    // proxyModel.setFilterRole(TextRole);
    // proxyModel.setSortRole(TitleRole);
}

BookModel::~BookModel()
{
    updateRows();
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
        auto text = QString::fromStdString(stmt.getColumn(1).getString());
        auto lastModifiedStr = QString::fromStdString(stmt.getColumn(2).getString());
        auto lastModified = QDate::fromString(lastModifiedStr, Qt::ISODate).toString("MMM d, yy");
        auto color = stmt.getColumn(3).getInt();
        auto rowId = stmt.getColumn(4).getInt();
        auto notes = QString::fromStdString(stmt.getColumn(5).getString());
        model.emplaceBack(rowId, title, text, lastModified, color, notes);
    }
    proxyModel.sort(0, Qt::AscendingOrder);
    layoutChanged();
}

void BookModel::selectAll()
{
    executeSelectQuery("SELECT title, bookmarkText, dateModified, kaeColor, annotationId, kaeNotes FROM annotations ORDER BY title, dateModified;");
}

void BookModel::searchAnnotations(QString query)
{
    proxyModel.setFilterRegularExpression(QRegularExpression(query, QRegularExpression::CaseInsensitiveOption));
}

// Open the application DB and assign it to appDB
bool BookModel::openApplicationDB(QString loc)
{
    try
    {
        qDebug() << "Opening application DB located at " << loc;
        appDB = std::make_unique<SQLite::Database>(loc.toStdString(), SQLite::OPEN_READWRITE);
        return true;
    }
    catch (SQLite::Exception ex)
    {
        qDebug() << "Failed to open application DB:" << ex.what();
        return false;
    }
}

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