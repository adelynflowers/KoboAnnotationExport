#ifndef PROXYMODEL_H
#define PROXYMODEL_H
#include <QtCore>
#include <QtQml/qqmlregistration.h>
#include <QSortFilterProxyModel>

class BookProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    BookProxyModel(QObject *parent = 0);
    ~BookProxyModel();

protected:
    bool lessThan(const QModelIndex &source_left, const QModelIndex &source_right) const;
    bool filterAcceptsRow(int source_row, const QModelIndex &source_parent) const;
};

#endif // PROXYMODEL_H