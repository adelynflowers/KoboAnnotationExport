#ifndef OUTERLIST_H
#define OUTERLIST_H
#include <QtCore>
#include <QtQml/qqmlregistration.h>
#include <QGuiApplication>

class InnerModel;

class NestedListViewModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    enum NestedListViewModelRoles
    {
        TitleRole = Qt::UserRole + 1,
        SubmodelRole = Qt::UserRole + 2,
    };
    explicit NestedListViewModel(QObject *parent = nullptr);
    ~NestedListViewModel();

public:
    Q_INVOKABLE int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;
    Q_INVOKABLE QVariant getInnerModelAt(int idx) const;

protected:
    QVector<InnerModel *> models;
    QHash<int, QByteArray> roles;
};
#endif