#ifndef BOOKMODEL_H
#define BOOKMODEL_H

#include <QtCore>
#include <QtQml/qqmlregistration.h>
#include <koboDB.h>
#include <QClipboard>
#include <QGuiApplication>

struct QAnnotation
{
    QString title;
    QString text;
};

class BookModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    // define roles (properties)
    enum RoleNames
    {
        TitleRole = Qt::UserRole,
        TextRole = Qt::UserRole + 1
    };
    explicit BookModel(QObject *parent = 0);
    ~BookModel();

    // QAbstractItemModel interface
    virtual int rowCount(const QModelIndex &parent) const;
    virtual QVariant data(const QModelIndex &index, int role) const;
    virtual QHash<int, QByteArray> roleNames() const;
    Q_INVOKABLE void openDB(QUrl);
    Q_INVOKABLE bool openAttachedDB();
    Q_INVOKABLE void blacklistDevice(QUrl);
    Q_INVOKABLE void copyToClipboard(QString);

public slots:
    void searchDevices();
signals:
    void deviceDetected(QUrl);

private:
    QStorageInfo findKoboDevice();
    QUrl getDeviceDBLoc(QStorageInfo);
    bool isNewDevice(QUrl);
    bool isBlacklisted(QUrl);

    QHash<QUrl, bool> blacklisted_devices;
    QList<QAnnotation> m_data;
    QHash<int, QByteArray> m_rolenames;
    QTimer *timer;
    QUrl currentDevicePath;
};

#endif // BOOKMODEL_H
