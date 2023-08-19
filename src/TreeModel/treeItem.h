#ifndef TREEITEM_H
#define TREEITEM_H
#include <QtCore>
#include <QtQml/qqmlregistration.h>
#include <QClipboard>
#include <QGuiApplication>
#include <memory>
class TreeItem
{
public:
    explicit TreeItem(const QList<QVariant> &data = QList<QVariant>(), TreeItem *parent = nullptr);
    explicit TreeItem(TreeItem *parent);
    ~TreeItem();

    TreeItem *child(int number);
    int childCount() const;
    int columnCount() const;
    QVariant data(int column) const;
    bool insertChildren(int position, int count, int columns);
    bool insertColumns(int position, int columns);
    TreeItem *parent();
    bool removeChildren(int position, int count);
    bool removeColumns(int position, int columns);
    int childNumber() const;
    bool setData(int column, const QVariant &value);
    // returns index added at
    int appendChild(TreeItem *child);
    TreeItem *createChild();
    void setParent(TreeItem *parent);
    // returns index added at
    int addData(const QVariant &data);

private:
    QList<TreeItem *> childItems;
    QList<QVariant> itemData;
    TreeItem *parentItem;
};

#endif