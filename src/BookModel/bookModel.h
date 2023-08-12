#ifndef BOOKMODEL_H
#define BOOKMODEL_H
/**
 * @file bookModel.h
 * @author Adelyn Flowers (adelyn.flowers@gmail.com)
 * @brief QML ListView model of kobo highlights
 * @version 0.1
 * @date 2023-08-12
 *
 * @copyright Copyright (c) 2023 Adelyn Flowers
 *
 */

#include <QtCore>
#include <QtQml/qqmlregistration.h>
#include <koboDB.h>
#include <QClipboard>
#include <QGuiApplication>

/**
 * @brief A Qt-friendly container for annotation information.
 *
 * An object representing one annotation, which has a book
 * title and annotated text.
 */
struct QAnnotation
{
    QString title; // book title
    QString text;  // annotation text
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
    // Roles allow QML to access data like properties
    enum RoleNames
    {
        TitleRole = Qt::UserRole,
        TextRole = Qt::UserRole + 1
    };

    /**
     * @brief Construct a new Book Model object.
     *
     * Role names and timer member are initialized. timer
     * ticks at intervals of 1s and is connected to the
     * searchDevices slot.
     *
     * TODO: Change timer to smart pointer
     * @param parent parent, used by Qt
     */
    explicit BookModel(QObject *parent = 0);

    /**
     * @brief Destroy the Book Model object
     *
     * Frees the timer member.
     *
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
     * @return Q_INVOKABLE
     */
    Q_INVOKABLE void openDB(QUrl);

    /**
     * @brief Searches for an attached Kobo device and
     * calls openDB on its database.
     *
     * @return Q_INVOKABLE
     */
    Q_INVOKABLE bool openAttachedDB();

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

    /**
     * @brief Filters model data to the annotations
     * matching the search string.
     *
     * @return Q_INVOKABLE
     */
    Q_INVOKABLE void searchBooks(QString);

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

    // List of blacklisted devices
    QHash<QUrl, bool> blacklisted_devices;

    // Annotation list
    QList<QAnnotation> m_data;

    // Role names hash table
    QHash<int, QByteArray> m_rolenames;

    // Timer for triggering device searching
    QTimer *timer;

    // Path of last opened device
    QUrl currentDevicePath;
};

#endif // BOOKMODEL_H
