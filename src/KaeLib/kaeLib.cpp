#include <kaeLib.h>

// Start the timer
KaeLib::KaeLib()
{
    timer.reset(new QTimer(this));
    connect(&(*timer), &QTimer::timeout, this, &KaeLib::searchDevices);
    timer->start(1000);
}

// Emit signal if a kobo device is found
void KaeLib::searchDevices()
{
    auto device = findKoboDevice();
    if (device.isValid())
    {
        auto url = getDeviceDBLoc(device).path();
        if (isNewDevice(url) && !isBlacklisted(url))
        {
            emit deviceDetected(url);
        }
    }
}

// Get the database path from a kobo device
QUrl KaeLib::getDeviceDBLoc(QStorageInfo device)
{
    auto dir = QDir(device.rootPath());
    dir.cd(".kobo");
    auto url = QUrl(dir.absoluteFilePath("KoboReader.sqlite"));
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