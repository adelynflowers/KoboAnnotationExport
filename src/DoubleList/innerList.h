#ifndef INNERLIST_H
#define INNERLIST_H

#include <QtCore>
#include <QtQuick>
#include <QtQml/qqmlregistration.h>

class InnerModel : public QAbstractListModel
{
    Q_PROPERTY(QString title READ getTitle)
    Q_OBJECT
    QML_ELEMENT
public:
    enum InnerModelRoles
    {
        AnnotationRole = Qt::UserRole + 3
    };

    explicit InnerModel(QObject *parent = nullptr);
    ~InnerModel();

    Q_INVOKABLE int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;
    QString getTitle();
    void setTitle(QString title);
    void appendData(QString data);

private:
    QList<QString> annotations;
    QString title;
    QHash<int, QByteArray> roles;
};
#endif // INNERLIST_H