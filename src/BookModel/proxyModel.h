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
    explicit BookProxyModel(QObject *parent = nullptr);
    ~BookProxyModel() override;
    void customSort(bool dateEnabled, bool titleEnabled, Qt::SortOrder order = Qt::AscendingOrder);

protected:
    bool lessThan(const QModelIndex &source_left, const QModelIndex &source_right) const override;
    bool filterAcceptsRow(int source_row, const QModelIndex &source_parent) const override;

    bool titleEnabled = true;
    bool dateEnabled = true;
};

#endif // PROXYMODEL_H