#ifndef KAELIB_H
#define KAELIB_H
/**
 * @file kaeLib.h
 * @author Adelyn Flowers (adelyn.flowers@gmail.com)
 * @brief The KaeLib class, which holds helper functions
 * for Kae to use in QML.
 * @version 0.1
 * @date 2023-08-12
 *
 * @copyright Copyright (c) 2023 Adelyn Flowers
 *
 */

#include <QtCore>
#include <QtQml/qqmlregistration.h>
#include <QClipboard>
#include <QGuiApplication>
#include <memory>
#include <SQLiteCpp/SQLiteCpp.h>

#define APP_DB_NAME "kae.db"

/**
 * @brief A class containing helper
 * functions for the entire application.
 *
 */
class KaeLib : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentDevice READ getCurrentDevice WRITE setCurrentDevice)
    QML_ELEMENT
public:
    /**
     * @brief Construct a new Kae Lib object.
     *
     * Initializes a timer to tick every second,
     * triggering a search for kobo devices to
     * open.
     *
     */
    KaeLib();

    Q_INVOKABLE void hello()
    {
        qDebug() << "Hello world!";
    }

    /**
     * @brief Adds a device to the blacklist.
     *
     * Blacklisted devices will not trigger a signal
     * emission from searchDevices.
     * @param path path to device db
     * @return Q_INVOKABLE
     */
    Q_INVOKABLE void blacklistDevice(QString path);

    /**
     * @brief Copies a QString to the clipboard.
     *
     * @param text text to be copied
     * @return Q_INVOKABLE
     */
    Q_INVOKABLE void copyToClipboard(QString text);

    /**
     * @brief Get the currently opened device.
     *
     * @return QString
     */
    QString getCurrentDevice();

    /**
     * @brief Set the currently opened device.
     *
     * @param path
     */
    void setCurrentDevice(QString path);

public slots:
    /**
     * @brief Emits deviceDetected if a suitable
     * Kobo device is found.
     */
    void searchDevices();
signals:
    /**
     * @brief Emits root path to db of an attached
     * Kobo device.
     *
     * @param dbPath path to database file
     */
    void deviceDetected(QString dbPath);

    /**
     * @brief Emits the path to the application DB after
     * initialization.
     *
     * @param dbPath path to application db file
     */
    void appReady(QString dbPath);

private:
    /**
     * @brief Searches for a mounted volume
     * with "kobo" in the name.
     *
     * @return QStorageInfo kobo device
     */
    QStorageInfo findKoboDevice();
    /**
     * @brief Get the database location of an
     * attached Kobo.
     *
     * @param device kobo device
     * @return QUrl Path to kobo db file.
     */
    QUrl getDeviceDBLoc(QStorageInfo device);

    /**
     * @brief Determines if a device path is the same
     * as currentDevicePath.
     *
     * @param url QUrl device path
     * @return true if device path is different
     * @return false if device path is the same
     */
    bool isNewDevice(QString dbPath);

    /**
     * @brief Determines if a device path is blacklisted
     * by looking it up in blacklisted_devices.
     *
     * @param url QUrl device path
     * @return true if device is blacklisted
     * @return false if it is not
     */
    bool isBlacklisted(QString dbPath);

    /**
     * @brief Get the Application DB path
     *
     * @return QString db path
     */
    QString getApplicationDB();

    /**
     * @brief Get the app data folder
     *
     * @return path to folder
     */
    QString getApplicationFolder();

    /**
     * @brief Creates the DB if it does not exist.
     */
    void initializeApplicationDB();

    // timer for device searching
    std::unique_ptr<QTimer> timer;

    // List of blacklisted devices
    QHash<QString, bool> blacklistedDevices;

    // Path of last opened device
    QString currentDevicePath;
};

#endif // KAELIB_H
