#include <kaeLib.h>

// Start the timer
KaeLib::KaeLib()
{
    timer.reset(new QTimer(this));
    connect(&(*timer), &QTimer::timeout, this, &KaeLib::searchDevices);
    timer->start(1000);

    QTimer::singleShot(500, this, &KaeLib::initializeApplicationDB);
}

KaeLib::~KaeLib()
{
}

// Emit signal if a kobo device is found
void KaeLib::searchDevices()
{
    auto device = findKoboDevice();
    if (device.isValid())
    {
        auto url = getDeviceDBLoc(device);
        if (isNewDevice(url) && !isBlacklisted(url))
        {
            qDebug() << "emitting db path " << url;
            emit deviceDetected(url);
        }
    }
}

// Get the database path from a kobo device
QString KaeLib::getDeviceDBLoc(QStorageInfo device)
{
    qDebug() << "root path is " << device.rootPath();
    auto dir = QDir(device.rootPath());
    qDebug() << "dir-ified it becomes " << dir;
    dir.cd(".kobo");
    qDebug() << "after cd: " << dir;
    auto url = dir.absoluteFilePath("KoboReader.sqlite");
    qDebug() << "absolute path: " << dir.absoluteFilePath("KoboReader.sqlite");
    qDebug() << "relative path: " << dir.relativeFilePath("KoboReader.sqlite");
    return url;
}

// Return device == last opened device
bool KaeLib::isNewDevice(QString path)
{
    return path != currentDevicePath;
}

// Blacklist a device
void KaeLib::blacklistDevice(QString path)
{
    this->blacklistedDevices[path] = true;
}

// Return if device is blacklisted
bool KaeLib::isBlacklisted(QString path)
{
    return this->blacklistedDevices[path];
}

// Copy text to clipboard
void KaeLib::copyToClipboard(QString text)
{
    QGuiApplication::clipboard()->setText(text);
}

// Find a kobo device and return it
QStorageInfo KaeLib::findKoboDevice()
{
    qDebug() << "*****************";
    qDebug() << "Starting kobo device search";
    QStorageInfo device;
    auto devices = QStorageInfo::mountedVolumes();
    auto searchTerm = QString("kobo");
    for (auto d : devices)
    {
        qDebug() << "Device found: " << d.displayName();
        if (d.displayName().contains(searchTerm, Qt::CaseInsensitive))
        {
            qDebug() << "Device accepted!";
            return d;
        }
        qDebug() << "Device rejected";
    }
    return device;
}

// Get current device
QString KaeLib::getCurrentDevice()
{
    return currentDevicePath;
}

// Set current device
void KaeLib::setCurrentDevice(QString path)
{
    currentDevicePath = path;
}

QString KaeLib::getApplicationFolder()
{
    return QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
}
// Returns the path to application DB
QString KaeLib::getApplicationDB()
{
    auto parentFolder = QDir(getApplicationFolder());
    auto dbPath = parentFolder.absoluteFilePath(APP_DB_NAME);
    return dbPath;
}

// Initializes the DB if it doesn't exist
void KaeLib::initializeApplicationDB()
{
    QDir appDir(getApplicationFolder());
    if (!appDir.exists())
    {
        qDebug() << "App data dir does not exist, creating";
        appDir.mkdir(getApplicationFolder());
    }

    auto dbLoc = getApplicationDB();
    if (!appDir.exists(APP_DB_NAME))
    {
        qDebug() << "Creating app db for the first time at " << dbLoc;
        SQLite::Database db(dbLoc.toStdString(), SQLite::OPEN_READWRITE | SQLite::OPEN_CREATE);
        const char *createAnnotationsTable = "CREATE TABLE annotations"
                                             "("
                                             "volumeId TEXT,"
                                             "bookmarkText TEXT UNIQUE,"
                                             "bookmarkAnnotation TEXT,"
                                             "dateCreated TEXT,"
                                             "dateModified TEXT,"
                                             "bookTitle TEXT,"
                                             "title TEXT,"
                                             "attribution TEXT"
                                             ")";
        SQLite::Transaction transaction(db);
        db.exec(createAnnotationsTable);
        transaction.commit();
    }
    qDebug() << "emitting app db ready";
    emit appReady(dbLoc);
    qDebug() << "emitted";
}

void KaeLib::showToast(QString message)
{
    emit toastReceived(message);
}