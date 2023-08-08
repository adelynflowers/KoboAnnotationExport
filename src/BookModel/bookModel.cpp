#include "bookModel.h"
#define DB_LOC "/home/adelynflowers/dev/qt-quick-project/src/KoboLib/data/KoboReader.sqlite"

BookModel::BookModel(QObject *parent)
    : QAbstractListModel(parent)
{
    // initialize custom roles that map to annotations
    this->m_rolenames[TitleRole] = "title";
    this->m_rolenames[TextRole] = "text";
}

BookModel::~BookModel()
{
}

int BookModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    // return our data count
    return m_data.count();
}

QVariant BookModel::data(const QModelIndex &index, int role) const
{
    // the index returns the requested row and column information.
    // we ignore the column and only use the row information
    int row = index.row();

    // boundary check for the row
    if (row < 0 || row >= m_data.count())
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
        return m_data.value(row).title;
    case TextRole:
        return m_data.value(row).text;
    }

    // The view asked for other data, just return an empty QVariant
    return QVariant();
}

QHash<int, QByteArray> BookModel::roleNames() const
{
    return this->m_rolenames;
}

void BookModel::openDB(QUrl loc)
{
    // initialize data with kobo DB annotations
    // TO-DO: How to convert this filename to something SQLite likes?
    // doesn't work with file:///
    qDebug() << loc.path();
    auto dbLoc = loc.path().toStdString();
    try
    {

        auto kdb = KoboDB::openKoboDB(dbLoc);
        auto annotations = kdb.extractAnnotations();
        QList<QAnnotation> data;
        layoutAboutToBeChanged();
        for (auto a : annotations)
        {
            auto qa = QAnnotation{
                .title = QString::fromStdString(a.title),
                .text = QString::fromStdString(a.text).trimmed(),
            };
            data.append(qa);
        }
        this->m_data = data;
        layoutChanged();
    }
    catch (SQLite::Exception &ex)
    {
        std::cerr << "Failed to open DB " << dbLoc << ": " << ex.what() << std::endl;
    }
}

void BookModel::findAttachedDB()
{
    auto devices = QStorageInfo::mountedVolumes();
    QStorageInfo kobo;
    auto searchTerm = QStringView(QString("kobo"));
    auto found = false;
    for (auto d : devices)
    {
        if (d.displayName().contains(searchTerm, Qt::CaseInsensitive))
        {
            found = true;
            qDebug() << "Attached Kobo found with name " << d.displayName();
            auto filePath = d.rootPath() + "/.kobo/KoboReader.sqlite";
            auto url = QUrl(filePath);
            qDebug() << "Opening DB at " << url;
            openDB(url);
            return;
        }
    }

    qDebug() << "No attached devices met criteria";
}