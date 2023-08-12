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

/**
 * @brief A class containing helper
 * functions for the entire application.
 *
 */
class KaeLib : public QObject
{
    Q_OBJECT
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
     *
     * @return Q_INVOKABLE
     */
    Q_INVOKABLE void blacklistDevice(QUrl);

    /**
     * @brief Copies a QString to the clipboard.
     *
     * @return Q_INVOKABLE
     */
    Q_INVOKABLE void copyToClipboard(QString);

public slots:
    /**
     * @brief Emits deviceDetected if a suitable
     * Kobo device is found.
     */
    void searchDevices();
signals:
    /**
     * @brief Emits root path of an attached
     * Kobo device.
     */
    void deviceDetected(QUrl);

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
     * @return QUrl Path to kobo db file.
     */
    QUrl getDeviceDBLoc(QStorageInfo);

    /**
     * @brief Determines if a device path is the same
     * as currentDevicePath.
     *
     * @return true if device path is different
     * @return false if device path is the same
     */
    bool isNewDevice(QUrl);

    /**
     * @brief Determines if a device path is blacklisted
     * by looking it up in blacklisted_devices.
     *
     * @return true if device is blacklisted
     * @return false if it is not
     */
    bool isBlacklisted(QUrl);

    // timer for device searching
    std::unique_ptr<QTimer> timer;

    // List of blacklisted devices
    QHash<QUrl, bool> blacklisted_devices;

    // Path of last opened device
    QUrl currentDevicePath;
};

#endif // KAELIB_H
