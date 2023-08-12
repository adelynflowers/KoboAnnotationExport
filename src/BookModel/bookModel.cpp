#include "bookModel.h"
#define DB_LOC "/home/adelynflowers/dev/qt-quick-project/src/KoboLib/data/KoboReader.sqlite"

// Initialize object with roles. Set off timer for
// device searching.
BookModel::BookModel(QObject *parent)
    : QAbstractListModel(parent)
{
    // initialize custom roles that map to annotations
    this->m_rolenames[TitleRole] = "title";
    this->m_rolenames[TextRole] = "text";
    QTimer *timer = new QTimer(this);
    connect(timer, &QTimer::timeout, this, &BookModel::searchDevices);
    timer->start(1000);
    this->timer = timer;
}

// Free the timer
BookModel::~BookModel()
{
    delete timer;
}

// Return the number of row in the model
int BookModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    // return our data count
    return m_data.count();
}

// Get model data at an index
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

// Link between qml properties and role names
QHash<int, QByteArray> BookModel::roleNames() const
{
    return this->m_rolenames;
}

// Find a kobo device and return it
QStorageInfo BookModel::findKoboDevice()
{
    QStorageInfo device;
    auto devices = QStorageInfo::mountedVolumes();
    auto searchTerm = QStringView(QString("kobo"));
    for (auto d : devices)
    {
        if (d.displayName().contains(searchTerm, Qt::CaseInsensitive))
        {
            return d;
        }
    }
    return device;
}

// Open a db with KoboDB and add its data
// to the model
void BookModel::openDB(QUrl loc)
{
    // initialize data with kobo DB annotations
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
            this->m_data.append(qa);
        }
        this->currentDevicePath = loc;
        layoutChanged();
    }
    catch (SQLite::Exception &ex)
    {
        std::cerr << "Failed to open DB " << dbLoc << ": " << ex.what() << std::endl;
    }
}

// Get the database path from a kobo device
QUrl BookModel::getDeviceDBLoc(QStorageInfo device)
{
    auto dir = QDir(device.rootPath());
    dir.cd(".kobo");
    auto url = QUrl(dir.absoluteFilePath("KoboReader.sqlite"));
    return url;
}

// Find a kobo device and call openDB on it
bool BookModel::openAttachedDB()
{
    auto device = findKoboDevice();
    if (device.isValid())
    {
        openDB(getDeviceDBLoc(device));
    }
    return false;
}

// Return device == last opened device
bool BookModel::isNewDevice(QUrl url)
{
    if (url != this->currentDevicePath)
    {
        return true;
    }
    else
    {
        return false;
    }
}

// Blacklist a device
void BookModel::blacklistDevice(QUrl url)
{
    this->blacklisted_devices[url] = true;
}

// Return if device is blacklisted
bool BookModel::isBlacklisted(QUrl url)
{
    return this->blacklisted_devices[url];
}

// Emit signal if a kobo device is found
void BookModel::searchDevices()
{
    auto device = findKoboDevice();
    if (device.isValid())
    {
        auto url = getDeviceDBLoc(device);
        if (isNewDevice(url) && !isBlacklisted(url))
        {
            emit deviceDetected(url);
        }
    }
}

// Copy text to clipboard
void BookModel::copyToClipboard(QString text)
{
    QGuiApplication::clipboard()->setText(text);
}

// Filter annotations based on search query
void BookModel::searchBooks(QString text)
{
    // TO-DO: Setup sqlite3 memory db and query
    return;
}