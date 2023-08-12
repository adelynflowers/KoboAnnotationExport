#include "bookModel.h"
#define DB_LOC "/home/adelynflowers/dev/qt-quick-project/src/KoboLib/data/KoboReader.sqlite"

// Initialize object with roles. Set off timer for
// device searching.
BookModel::BookModel(QObject *parent)
    : QAbstractListModel(parent)
{
    // initialize custom roles that map to annotations
    rolenames[TitleRole] = "title";
    rolenames[TextRole] = "text";
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
        return model.value(row).title;
    case TextRole:
        return model.value(row).text;
    }

    // The view asked for other data, just return an empty QVariant
    return QVariant();
}

// Link between qml properties and role names
QHash<int, QByteArray> BookModel::roleNames() const
{
    return this->rolenames;
}

// Open a db with KoboDB and add its data
// to the model
bool BookModel::openDB(QUrl loc)
{
    // initialize model with kobo DB annotations
    // TO-DO: How to convert this filename to something SQLite likes?
    // doesn't work with file:///
    auto dbLoc = loc.path().toStdString();
    try
    {

        auto kdb = KoboDB::openKoboDB(dbLoc);
        auto annotations = kdb.extractAnnotations();
        layoutAboutToBeChanged();
        for (auto a : annotations)
        {
            auto qa = QAnnotation{
                .title = QString::fromStdString(a.title),
                .text = QString::fromStdString(a.text).trimmed(),
            };
            model.append(qa);
        }
        layoutChanged();
        return true;
    }
    catch (SQLite::Exception &ex)
    {
        std::cerr << "Failed to open DB " << dbLoc << ": " << ex.what() << std::endl;
        return false;
    }
}